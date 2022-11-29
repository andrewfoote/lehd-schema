# Instructions

How to build the docs. 

## Build the current version of the schema

1. Install or update asciidoctor
    ```shell
    # validate that the ruby 2.6 is the active version
    # if not, install and configure ruby on your path
    ruby --version
    which ruby
    
    # install packages
    gem install asciidoctor
    gem install asciidoctor-pdf
    ```

2. Load the schema version from the environment variable
    ```shell
    # set the $SCHEMA_VERSION environment variable
    export $(xargs <.env)
    ```

3. Build the docs

    ```shell
    # html only
    ./generate_schema_docs.sh -v $SCHEMA_VERSION
    # html and pdf
    ./generate_schema_docs.sh -v $SCHEMA_VERSION -p
    ```

4. Deploy the output files
    
    ```shell
    # html, and pdf are in the ./dist directory
    cp ./dist /path/to/schemas/$SCHEMA_VERSION -r
    # csv files are in the ./src directory
    cp ./src/*.csv /path/to/schemas/$SCHEMA_VERSION
    # txt files
    cp ./src/*.txt /path/to/schemas/$SCHEMA_VERSION
    ```

5. Correct csv line endings
    
    ```shell
    cd /path/to/schemas/$SCHEMA_VERSION
    for f in $(ls *.csv); do echo processing ${f}...; dos2unix $f; done      
    ```
   
6. (Optional) Add header on official deploy

    When deploying an official version there's an convenience header that can be added to the top of the html files. This is done by running the following command. 

    ```shell
   cd /path/to/schemas/
   cp $OLD_SCHEMA_VERSION/HEADER.html $SCHEMA_VERSION/
   ```
