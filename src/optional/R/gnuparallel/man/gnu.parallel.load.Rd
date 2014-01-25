\name{gnu.parallel.load}
\alias{gnu.parallel.load}
\title{Read the contents of the stdout and stderr files as 1 field each}
\usage{
  gnu.parallel.load(filenametable)
}
\arguments{
  \item{filenametable}{filenametable from gnu.parallel.filenames}
}
\value{
  table with a column for each of GNU Parallel's input sources and 2 columns for content of stdout and stderr
}
\description{
  Read the contents of the stdout and stderr files as 1 field each.
}
\author{
  Ole Tange \email{tange@gnu.org}
}
\references{
  Tange, O. (2011) \emph{GNU Parallel - The Command-Line Power Tool} ;login:
  The USENIX Magazine, February 2011:42-47.
}
