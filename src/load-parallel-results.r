## Copyright (C) 2014 Ole Tange, David Rosenberg, and Free Software
## Foundation, Inc.
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see <http://www.gnu.org/licenses/>
## or write to the Free Software Foundation, Inc., 51 Franklin St,
## Fifth Floor, Boston, MA 02110-1301 USA
##
##
## LIBRARY FOR READING GNU PARALLEL RESULTS 
##
## Example:
## parallel --results my/results/dir --header : 'printf "FOO={foo}\\tBAR={bar}\\n";paste <(seq {bar}) <(seq {bar} -1 1)' :::: <(echo foo; seq 100) <(echo bar; seq 10)
##
## dir="my/results/dir"
## filenametable <- load_parallel_results_filenames(dir);
## raw <- load_parallel_results_raw(filenametable)
## newlines <- load_parallel_results_split_on_newline(filenametable)
## rawdt <- raw_to_data.table(raw)
## rawdf <- raw_to_data.frame(raw)

load_parallel_results_filenames <- function(resdir) {
  ## Find files called .../stdout
  stdoutnames <- list.files(path=resdir, pattern="stdout", recursive=T);
  ## Find files called .../stderr
  stderrnames <- list.files(path=resdir, pattern="stderr", recursive=T);
  if(length(stdoutnames) == 0) {
    ## Return empty data frame if no files found
    return(data.frame());
  }
  ## The argument names are every other dir level
  ## The argument values are every other dir level
  ## e.g. my/results/dir/age/18/chromosome/20/stdout
  m <- matrix(unlist(strsplit(stdoutnames, "/")),nrow = length(stdoutnames),byrow=T);
  filenametable <- as.table(m[,c(F,T)]);
  ## Append the stdout and stderr filenames
  filenametable <- cbind(filenametable,
                         paste(resdir,unlist(stdoutnames),sep="/"),
                         paste(resdir,unlist(stderrnames),sep="/"));
  colnames(filenametable) <- c(strsplit(stdoutnames[1],"/")[[1]][c(T,F)],"stderr");
  return(filenametable);
}

load_parallel_results_raw <- function(filenametable) {
  ## Read the files given in column stdout
  stdoutcontents <-
    lapply(filenametable[,c("stdout")],
           function(filename) {
             return(readChar(filename, file.info(filename)$size));
           } );
  ## Read the files given in column stderr
  stderrcontents <-
    lapply(filenametable[,c("stderr")],
           function(filename) {
             return(readChar(filename, file.info(filename)$size));
           } );
  ## Replace filenames with file contents
  filenametable[,c("stdout","stderr")] <-
    c(as.character(stdoutcontents),as.character(stderrcontents));
  return(filenametable);
}

load_parallel_results_split_on_newline <- function(filenametable,split="\n") {
  raw <- load_parallel_results_raw(filenametable);
  ## Keep all columns except stdout and stderr
  varnames = setdiff(colnames(raw), c("stdout","stderr"))
  ## Find the id of the non-stdout and non-stderr columns
  header_cols = which(colnames(raw) %in% varnames)
  ## Split stdout on \n
  splits = strsplit(raw[,"stdout"], split)
  ## Compute lengths of all the lines
  lens = sapply(splits, length)
  ## The arguments should be repeated as many times as there are lines
  reps = rep(1:nrow(raw), lens)
  ## Merge the repeating argument and the lines into a matrix
  m = cbind(raw[reps, header_cols], unlist(splits))
  return(m)
}

raw_to_data.table <- function(raw, ...) {
  require(data.table)
  ## Keep all columns except stdout and stderr
  varnames = setdiff(colnames(raw), c("stdout","stderr"))  
  ## Remove rownames
  rownames(raw) = NULL
  ## after data.table feature request the as.data.frame can be skipped
  ## and will thus be much faster
  ddt = as.data.table(as.data.frame(raw,stringsAsFactors=FALSE))
  ## ensure fread knows stdout is string and not filename by appending \n
  ddt[, stdout := paste0(stdout,"\n")]
  ## drop files with empty stdout
  ddd = ddt[nchar(stdout)>1,fread(stdout, header=FALSE, ...), by=varnames]
  return(ddd)
}

raw_to_data.frame <- function(raw, ...) {
  require(plyr)
  ## Convert to data.frame without factors
  raw = as.data.frame(raw, stringsAsFactors = FALSE)
  ## Keep all columns except stdout and stderr
  varnames = setdiff(colnames(raw), c("stdout","stderr"))  
  
  dd = ddply(raw, .variables=varnames, function(row) {
    ## Ignore empty stdouts
    if (nchar(row[,"stdout"]) == 0) {
      return(NULL)
    }
    ## Read stdout with read.table
    con <- textConnection(row[,"stdout"], open = "r")
    d = read.table(con, header=FALSE, ...)
    return(d)
  })

  return(dd)
}
