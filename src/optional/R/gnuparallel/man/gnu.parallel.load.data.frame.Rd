\name{gnu.parallel.load.data.frame}
\alias{gnu.parallel.load.data.frame}
\title{Read the contents of the stdout and produce a row for each line of stdout split into columns on TAB}
\usage{
  gnu.parallel.load.data.frame(filenametable,...)
}
\arguments{
  \item{filenametable}{filenametable from gnu.parallel.filenames}
  \item{...}{passed on}
}
\value{
  table with a column for each of GNU Parallel's input sources and
  stdout split by TAB.
}
\description{
  Read the contents of the stdout and produce a row for each line of
  stdout split into columns on TAB.
}
\author{
  Ole Tange \email{tange@gnu.org}, David Rosenberg
}
\references{
  Tange, O. (2011) \emph{GNU Parallel - The Command-Line Power Tool} ;login:
  The USENIX Magazine, February 2011:42-47.
}
