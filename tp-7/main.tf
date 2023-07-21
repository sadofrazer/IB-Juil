data "local_file" "file2" {
  filename = "files/fsa-file2.txt"
}



resource "local_file" "file1" {
  filename = "files/fsa-file1.txt"
  content = "Bonjour à tous … je source mes données d’un fichier d'ID : ${data.local_file.file2.id}"
}


variable "filenames" {
  type = list(string)
  default = ["files/fsa-file4.txt", "files/fsa-file6.txt", "files/fsa-file5.txt", "files/fsa-file3.txt" ]
}

resource "local_file" "files" {
  for_each = toset(var.filenames)
  filename = each.value
  content = each.value
}

resource "local_file" "files-c" {
  count = length(var.filenames)
  filename = "${var.filenames[count.index]}-count"
  content = "${var.filenames[count.index]}-count"
  lifecycle {
    create_before_destroy = true
  }
}