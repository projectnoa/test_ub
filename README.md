## RSS / CSV file parser

This Ruby script is intended to read a RSS feed or a File and 
execute 2 operations.

cut: trims all 'title' and 'description' items to 10 characters 
if it exceeds them.
replace: replace the occurrences of a string with the specified
substitution.

in order to execute this script please use the following patters
or just use the ```-h``` flag for help.

```shell
ruby main.rb --input=https://www.feedforall.com/sample.xml --convert=cut --output=result.txt

ruby main.rb -i sample.txt -c cut,replace(/123/abc/)

ruby main.rb --input=sample.txt --convert=replace(/abc/def/)
```

### Juan Reyes