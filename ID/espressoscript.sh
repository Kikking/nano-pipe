#!/bin/bash
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
# Define color codes
RED=$(tput setaf 1)  # Red color
RESET=$(tput sgr0)   # Reset color


TARGET="$1"
CLEAN="${2:-"clean"}"

# Generate TSV file
col1="/mnt/d/SGNEX/mini_bam/${TARGET}.bam"
col2="$TARGET"
echo -e "$col1\t$col2" > "/mnt/e/espresso_realm/${TARGET}.tsv"
echo "::: Created ${TARGET}.tsv :::::>"

echo "::: PREPROCESSING... :::::>"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_S.pl -L /mnt/e/espresso_realm/${TARGET}.tsv -F $SIRV_REF -A $SIRV_ANNO -O /mnt/e/espresso_realm/${TARGET}

echo "::: CORRECTING... :::::>"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_C.pl -I /mnt/e/espresso_realm/${TARGET} -F $SIRV_REF -X 0

echo "::: QUANTIFYING... :::::>"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_Q.pl -A $SIRV_ANNO -L /mnt/e/espresso_realm/${TARGET}/samples.tsv.updated

echo "::: MOVING... :::::>"
mv /mnt/e/espresso_realm/${TARGET}/samples_N2_R0_updated.gtf /mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf
mv /mnt/e/espresso_realm/${TARGET}/samples_N2_R0_abundance.esp /mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.esp

case "$CLEAN" in
    force)
        echo "Removing /mnt/e/espresso_realm/${TARGET}"
        rm -r "/mnt/e/espresso_realm/${TARGET}"
        ;;
    clean)
        if [ -e "/mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf" ]; then
            echo "Removing /mnt/e/espresso_realm/${TARGET}"
            rm -r "/mnt/e/espresso_realm/${TARGET}"
        else
            echo "${RED}File /mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf does not exist. Keeping /mnt/e/espresso_realm/${TARGET}${RESET}"
        fi
        ;;
    keep)
        echo "################ KEPT TMP FILES ##########################"
        ;;
    *)
        echo "Error: Invalid clean option '$CLEAN'."
        exit 1
        ;;
esac