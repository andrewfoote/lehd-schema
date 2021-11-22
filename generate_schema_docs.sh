#!/usr/bin/env bash

# Location of this script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

############################################################
# Help                                                     #
############################################################
help() {
  # Display help
  echo "Generate the LEHD schema documentation"
  echo
  echo "Process and generate the official schema output"
  echo "Excluding binary files (shp, zip)."
  echo
  echo "Syntax: generate_schema_docs.sh [-p|h] [-v <version string>]"
  echo "options:"
  echo "h     Print this Help."
  echo "p     Generate PDF output alongside the html"
  echo "v     Generate schema with version number"
  echo
  echo "Example:"
  echo "./generate_schema_docs -v V1.2.3"
  echo
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# No arguments
if [[ $# -eq 0 ]]; then
  help
  exit 1
fi

# Parse arguments
while getopts ":hv:p" option; do
  case $option in
  h) # display help
    help
    exit 1
    ;;
  p) # generate PDF
    generate_pdf=true
    ;;
  v) # Enter a schema version
    version=$OPTARG ;;
  \?) # Invalid option
    echo "Error: invalid argument"
    echo
    help
    exit 1
    ;;
  esac
done

source_dir=${SCRIPT_DIR}/src
destination_dir=${SCRIPT_DIR}/dist
lib_dir=${SCRIPT_DIR}/lib

# clean create output folder
rm -rf $destination_dir
mkdir $destination_dir

echo "Info: generating schema docs..."

# move into the src directory
cd $source_dir >/dev/null

# generate public schema doc
asciidoctor -r ${lib_dir}/csvsubcolumn-include-processor.rb \
  -a schemaversion=$version \
  -a outfilesuffix=.html \
  -o ${destination_dir}/lehd_public_use_schema.html \
  lehd_public_use_schema.asciidoc

# generate the csv naming doc
asciidoctor -r ${lib_dir}/csvsubcolumn-include-processor.rb \
  -a schemaversion=$version \
  -a outfilesuffix=.html \
  -o ${destination_dir}/lehd_csv_naming.html \
  lehd_csv_naming.asciidoc

# generate shapefiles doc
asciidoctor -r ${lib_dir}/csvsubcolumn-include-processor.rb \
  -a schemaversion=$version \
  -a outfilesuffix=.html \
  -o ${destination_dir}/lehd_shapefiles.html \
  lehd_shapefiles.asciidoc

# generate changelog
asciidoctor -r ${lib_dir}/csvsubcolumn-include-processor.rb \
  -a schemaversion=$version \
  -a outfilesuffix=.html \
  -o ${destination_dir}/lehd_changelog.html \
  lehd_changelog.asciidoc

# generate PDF versions
if [ "$generate_pdf" = true ] ; then
  asciidoctor-pdf -r ${lib_dir}/csvsubcolumn-include-processor.rb \
    -a schemaversion=$version \
    -o ${destination_dir}/lehd_public_use_schema.pdf \
    lehd_public_use_schema.asciidoc

  asciidoctor-pdf -r ${lib_dir}/csvsubcolumn-include-processor.rb \
    -a schemaversion=$version \
    -o ${destination_dir}/lehd_csv_naming.pdf \
    lehd_csv_naming.asciidoc

  asciidoctor-pdf -r ${lib_dir}/csvsubcolumn-include-processor.rb \
    -a schemaversion=$version \
    -o ${destination_dir}/lehd_shapefiles.pdf \
    lehd_shapefiles.asciidoc

  asciidoctor-pdf -r ${lib_dir}/csvsubcolumn-include-processor.rb \
    -a schemaversion=$version \
    -o ${destination_dir}/lehd_changelog.pdf \
    lehd_changelog.asciidoc
fi

# return to the root dir
cd - >/dev/null

echo "Info: done"
