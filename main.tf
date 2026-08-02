# simple file


resource local_file myfile1 {

filename = "a.txt"
content = "hello world"
file_permission = "0444"

}
