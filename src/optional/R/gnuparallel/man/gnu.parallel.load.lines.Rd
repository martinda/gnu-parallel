\name{gnu.parallel.load.lines}
\alias{gnu.parallel.load.lines}
\title{Read the contents of the stdout and produce a row for each line of stdout}
\usage{
  gnu.parallel.load.lines(filenametable,split="\n")
}
\arguments{
  \item{filenametable}{filenametable from gnu.parallel.filenames}
  \item{split}{defaults to newline}
}
\value{
  table with a column for each of GNU Parallel's input sources and a
  column for content of stdout
}
\description{
  Read the contents of the stdout and produce a row for each line of stdout.
}
\author{
  Ole Tange \email{tange@gnu.org}, David Rosenberg
}
\references{
  Tange, O. (2011) \emph{GNU Parallel - The Command-Line Power Tool} ;login:
  The USENIX Magazine, February 2011:42-47.
}
