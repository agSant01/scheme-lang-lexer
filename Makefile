# make test (or just: make)
#    generates lexer & parser, compiles all *.java files, and runs test
#
# To override  VARIABLE in this make file 
# execute the make command with VAR_NAME=<NEW VALUE>
# Example:
#	make compile JVM_HEAP_SIZE=1024

# vars to override
SCHEME_FILE 		= input-test1.scm
JVM_HEAP_SIZE		= 256				# MB
# input scheme file to tokenize
SCHEME_FILE_PATH	=
TEST_EXPECTED_PATH	=

# test data
TEST_IN_FOLDER		= ./src/test/data
TEST_IN_SCHEME      = $(SCHEME_FILE)
SCHEME_FILE_PATH	= $(TEST_IN_FOLDER)/$(TEST_IN_SCHEME)
TEST_OUT			= $(SCHEME_FILE).tokenized
TEST_EXPECTED		= $(SCHEME_FILE).expected
TEST_EXPECTED_PATH	= $(TEST_IN_FOLDER)/$(TEST_EXPECTED)
OUT_TOKNZED_PATH  	= $(OUT_TOKNZTION_DIR)/$(TEST_OUT)

# folder definitions
OUT 	 			= out
LIB 	 			= lib
OUT_JAVA 			= $(OUT)/java
OUT_CLASS 			= $(OUT)/class
OUT_TOKNZTION_DIR 	= $(OUT)/tokenizer-output
JFLEX_JAR   		= $(LIB)/jflex-full-1.8.2.jar

# jflex input
LEXER_IN 			= src/main/jflex/schemeScanner.flex
LEXER_CLASS 		= SchemeScanner
LEXER  				= $(OUT_JAVA)/$(LEXER_CLASS).java

all: test

compile: $(OUT)/$(LEXER_CLASS).class

$(OUT)/$(LEXER_CLASS).class:
	java -Xmx$(JVM_HEAP_SIZE)m -jar $(JFLEX_JAR) $(LEXER_IN) -d $(OUT_JAVA)
	javac -d $(OUT_CLASS) $(OUT_JAVA)/*.java

run:
	mkdir -p $(OUT_TOKNZTION_DIR)
	java -cp $(OUT_CLASS) $(LEXER_CLASS) $(SCHEME_FILE_PATH) > $(OUT_TOKNZED_PATH)

test: run
	@(diff $(OUT_TOKNZED_PATH) $(TEST_EXPECTED_PATH) && echo "Test OK!") || (echo "Test FAILED"; exit 1)

clean:
	rm -rf $(OUT)/*
