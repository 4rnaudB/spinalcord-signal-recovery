# This script runs all tSNR post-processing scripts for a given subject
# Inputs:
# $1: The path to the subject folder
# Outputs:
# - tSNR maps for all shim options
# - Registered tSNR maps
# - Mean tSNR maps
# - tSNR per level maps
# - Reference files
# - QC files
#

SUBJECT_PATH=$1

# Get the full path of the script
SCRIPT_PATH=$(dirname $0)
echo $SCRIPT_PATH

# Shim paths
BASELINE_PATH=$SUBJECT_PATH/Baseline
DynShim_PATH=$SUBJECT_PATH/DynShim
SigRec_PATH=$SUBJECT_PATH/SigRec
SigRec_w0001_PATH=$SUBJECT_PATH/SigRec_w0001
SigRec_w1_PATH=$SUBJECT_PATH/SigRec_w1


for SHIM_PATH in {$BASELINE_PATH,$DynShim_PATH,$SigRec_PATH,$SigRec_w0001_PATH,$SigRec_w1_PATH}
do
    if test -d $SHIM_PATH; then
        EPI_60vol_PATH=$(find $SHIM_PATH/EPIs -name "*_60vol.nii.gz")
        OPT_NAME=$(basename $SHIM_PATH)
        "$SCRIPT_PATH/tSNR_sc.sh" $EPI_60vol_PATH $OPT_NAME
    fi
done

# Prepare reference
REF_FOLDER_PATH=$DynShim_PATH
t1w_PATH=$SUBJECT_PATH/T1w/T1w.nii
"$SCRIPT_PATH/prepare_ref.sh" $REF_FOLDER_PATH $t1w_PATH

# Register tSNR
for SHIM_PATH in {$BASELINE_PATH,$DynShim_PATH,$SigRec_PATH,$SigRec_w0001_PATH,$SigRec_w1_PATH}
do
    REF_FOLDER_PATH=$DynShim_PATH
    t1w_FOLDER_PATH=$SUBJECT_PATH/T1w
    INPUT_FOLDER_PATH=$SHIM_PATH
    #test if shim path exist
    if test -d $SHIM_PATH; then
        "$SCRIPT_PATH/register_tSNR.sh" $REF_FOLDER_PATH $t1w_FOLDER_PATH $INPUT_FOLDER_PATH
    fi
done