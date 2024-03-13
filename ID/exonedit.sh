

# Assuming your GTF file is named "data.gtf"
awk '$3 == "exon" {split($9,/,/"exon_number /); $9 = "exon_number \"" gensub(/^ */, "", 1, $2)"\""} 1' data.gtf > modified_data.gtf
awk 'BEGIN {counter = 0} $3 == "exon" {split($9,/,/"exon_number /); $9 = "exon_number \"" counter++ "\"} 1' test.gtf > modified_data.gtf

# Explanation:
  - `$3 == "exon"`: This condition checks if the third column (type) is equal to "exon". This filters lines for exon features.
  - `split($9,/,/"exon_id /)`: Splits the ninth column (containing the current exon_id) based on comma and the string `"exon_id "`. This separates the value from the surrounding text.
  - `gensub(/^ */, "", 1, $2)`: This function removes any leading spaces from the captured value in the second element of the split array (`$2`).
  - `$9 = "exon_id \"" gensub ... "\"\""`: This constructs a new string for column 9 with `"exon_id "`, the modified value, and closing quotation marks.
  - `1`: This prints the modified line (along with any unchanged lines).
  - `> modified_data.gtf`: This redirects the output to a new file named "modified_data.gtf".
