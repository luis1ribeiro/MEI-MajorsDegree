/**
 * First-order logic revision exercises based on a simple model of a
 * file system trash can.
 *
 * The model has 3 unary predicates (sets), File, Trash and
 * Protected, the latter two a sub-set of File. There is a binary
 * predicate, link, a sub-set of File x File.
 *
 * Solve the following exercises using only Alloy's first-order
 * logic:
 *	- terms 't' are variables
 *	- atomic formulas are either term comparisons 't1 = t2' and
 * 't1 != t2' or n-ary predicate tests 't1 -> ... -> tn in P' and
 * 't1 -> ... -> tn not in P'
 *	- formulas are composed by
 *		- Boolean connectives 'not', 'and', 'or' and 'implies'
 *		- quantifications 'all' and 'some' over unary predicates
 **/

/* The set of files in the file system. */
sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}
/* The set of protected files. */
sig Protected in File {}

/* The trash is empty. */
pred inv1 {
  no Trash
}

/* All files are deleted. */
pred inv2 {
  File = Trash
}

/* Some file is deleted. */
pred inv3 {
  some Trash
}

/* Protected files cannot be deleted. */
pred inv4 {
  // Interseçao dos conjuntos
  no Trash & Protected
}

/* All unprotected files are deleted.. */
pred inv5 {
  File - Protected in Trash
}

/* A file links to at most one file. */
pred inv6 {
  //all x : File | lone x.link
  // Quero garantir a simplicidade (como uma função) então a imagem tem que ser co-reflexiva
  ~link.link in iden //o link.~link não garante, apenas garante que 2 links não se ligam a mesma imagem (Garante a injectividade)
}

/* There is no deleted link. */
pred inv7 {
  //all t : Trash | no link.t
  no link.Trash
  //all f : File | f.link in (File - Trash)
}

/* There are no links. */
pred inv8 {
  no link // all x : File | no x.link
}

/* A link does not link to another link. */
pred inv9 {
  no link.link
  // all f : File | some f.link imples no f.link.link
}

/* If a link is deleted, so is the file it links to. */
pred inv10 {
  Trash.link in Trash
}

