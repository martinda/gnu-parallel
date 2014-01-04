
load_parallel_results <- function(resdir) {
  ## Find files called .../stdout
  stdoutnames <- list.files(path=resdir, pattern="stdout", recursive=T);
  ## Read them
  stdoutcontents <-
    lapply(stdoutnames, function(x) { return(paste(readLines(paste(resdir,x,sep="/")),collapse="\n")) } );
  ## Find files called .../stderr
  stderrnames <- list.files(path=resdir, pattern="stderr", recursive=T);
  ## Read them
  stderrcontents <-
    lapply(stderrnames, function(x) { return(paste(readLines(paste(resdir,x,sep="/")),collapse="\n")) } );
  if(length(stdoutnames) == 0) {
    ## Return empty data frame if no files found
    return(data.frame());
  }

  ## Make the columns containing the variable values
  m <- matrix(unlist(strsplit(stdoutnames, "/")),nrow = length(stdoutnames),byrow=T);
  mm <- m[,c(F,T)];
  ## Append the stdout and stderr column
  mmm <- cbind(mm,unlist(stdoutcontents),unlist(stderrcontents));
  colnames(mmm) <- c(strsplit(stdoutnames[1],"/")[[1]][c(T,F)],"stderr");
  ## Example:
  ## parallel --results my/res/dir --header : 'echo {};seq {myvar2}' ::: myvar1 1 2 ::: myvar2 A B
   
  ##  > load_parallel_results("my/res/dir")
  ##       myvar1 myvar2 stdout      stderr
  ##  [1,] "1"    "A"    "1 A\n1"    ""
  ##  [2,] "1"    "B"    "1 B\n1"    ""
  ##  [3,] "2"    "A"    "2 A\n1\n2" ""
  ##  [4,] "2"    "B"    "2 B\n1\n2" ""
  return(mmm);    
}
