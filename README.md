# Text Positivity Classifier

### Jonathan Osborne Contreras
### Florida Polytechnic University
### josborne3693@floridapoly.edu

## Clone the Repository
```
$ git clone https://github.com/Josborne3693/fpu-text-positivity.git
```

## Download and Build fastText

```
$ cd fpu-text-positivity
$ git clone https://github.com/facebookresearch/fastText.git
$ cd fastText
$ make
```

## Run main.sh

usage:  $0 [-h] | [-f | -l | -L] file
-- classifies text into the predictions folder --
where:
-h | --help   show this help text
-l | --lines  classify each line of the file individually
-f | --file   classify the entire file as if it were one line
-L | --live   classify each line input to stdin
            - live should only contain [a-z]*[0-9]*[#]*

NOTE: if the input filename already exists in the
predictions folder, those files WILL be overwritten

E.g.
```
$ ./main.sh --lines samples/tweets1.txt
```

This is by no means a complete, or great, project.
It was simply used for my personal educational purposes.
