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

#' Functions for reading GNU Parallel results dir
#'
#' \tabular{ll}{
#' Package: \tab gnuparallel\cr
#' Type: \tab Package\cr
#' Version: \tab 0.1\cr
#' Date: \tab 2014-01-22\cr
#' License: \tab GPL >= 3\cr
#' LazyLoad: \tab no\cr
#' }
#' 
#' Implements a number of functions for reading GNU Parallel results dir
#'
#' @name gnuparallel-package
#' @aliases gnuparallel
#' @docType package
#' @title Results dir loading
#' @author Ole Tange \email{tange@@gnu.org}
#' @references
#' Tange, O. (2011) GNU Parallel - The Command-Line Power Tool, ;login: The USENIX Magazine, February 2011:42-47.
#' Talbot, J. (2011) labeling R-package, CRAN 2011.
#' @keywords parallel
#' @seealso \code{\link{gnu.parallel.filenames}}, \code{\link{gnu.parallel.load}},
#' \code{\link{gnu.parallel.load.data.frame}}, \code{\link{gnu.parallel.load.data.table}},
#' \code{\link{gnu.parallel.load.lines}}
#' @examples
#' library(gnuparallel)
#' system("parallel --results foobar printf out{1}\\\\\\\\tout{2}\\\\\\\\nline2{1}\\\\\\\\t{2}\\\\\\\\n ::: a b c ::: 4 5 6")
#' fn <- gnu.parallel.filenames("foobar")
#' gnu.parallel.load(fn)
#' gnu.parallel.load.lines(fn)
#' gnu.parallel.load.data.frame(fn)
#' gnu.parallel.load.data.table(fn)
c()


#' Find the filenames in a results dir
#'
#' @param resdir results dir from GNU Parallel's -{}-results
#' @return filenametable with a column for each of GNU Parallel's input sources and a column for file name of both stdout and stderr
#' @export
gnu.parallel.filenames <- function(resdir) {
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

#' Read the contents of the stdout and stderr files as 1 field each
#'
#' @param filenametable from gnu.parallel.filenames
#' @return table with a column for each of GNU Parallel's input sources and 2 columns for content of stdout and stderr
#' @export
gnu.parallel.load <- function(filenametable) {
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

#' Read the contents of the stdout and produce a row for each line of stdout
#'
#' @param filenametable from gnu.parallel.filenames
#' @return table with a column for each of GNU Parallel's input sources and a column for content of stdout
#' @export
gnu.parallel.load.lines <- function(filenametable,split="\n") {
  raw <- gnu.parallel.load(filenametable);
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
  ## Set the stdout colname
  colnames(m)[length(colnames(m))] <- "stdout"
  return(m)
}

#' Read the contents of the stdout and produce a row for each line of stdout split into columns on \t
#'
#' @param filenametable from gnu.parallel.filenames
#' @return table with a column for each of GNU Parallel's input sources and stdout split by \t
#' @export
gnu.parallel.load.data.table <- function(filenametable, ...) {
  raw <- gnu.parallel.load(filenametable);
  require(data.table)
  ## Keep all columns except stdout and stderr
  varnames = setdiff(colnames(raw), c("stdout","stderr"))  
  ## after data.table feature request the as.data.frame can be skipped
  ## and will thus be much faster
  ddt = as.data.table(as.data.frame(raw,stringsAsFactors=FALSE))
  ## ensure fread knows stdout is string and not filename by appending \n
  ddt[, stdout := paste0(stdout,"\n")]
  ## drop files with empty stdout
  ddd = ddt[nchar(stdout)>1,fread(stdout, header=FALSE, ...), by=varnames]
  return(ddd)
}

#' Read the contents of the stdout and produce a row for each line of stdout split into columns on \t
#'
#' @param filenametable from gnu.parallel.filenames
#' @return table with a column for each of GNU Parallel's input sources and stdout split by \t
#' @export
gnu.parallel.load.data.frame <- function(filenametable, ...) {
  raw <- gnu.parallel.load(filenametable);
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
