/**
 * First-order logic revision exercises based on a simple model of a
 * classroom management system.
 *
 * The model has 5 unary predicates (sets), Person, Student, Teacher,
 * Group and Class, Student and Teacher a sub-set of Person. There are
 * two binary predicates, Tutors a sub-set of Person x Person, and
 * Teaches a sub-set of Person x Teaches. There is also a ternary
 * predicate Groups, sub-set of Class x Person x Group.
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

/* The registered persons. */
sig Person  {
	/* Each person tutors a set of persons. */
	Tutors : set Person,
	/* Each person teaches a set of classes. */
	Teaches : set Class
}

/* The registered groups. */
sig Group {}

/* The registered classes. */
sig Class  {
	/* Each class has a set of persons assigned to a group. */
	Groups : Person -> Group
}

/* Some persons are teachers. */
sig Teacher in Person  {}

/* Some persons are students. */
sig Student in Person  {}

/* Every person is a student. */
pred inv1 {
  Person = Student
}

/* There are no teachers. */
pred inv2 {
  no Teacher
}

/* No person is both a student and a teacher. */
pred inv3 {
  no (Student & Teacher)
}

/* No person is neither a student nor a teacher. */
pred inv4 {
  //all x : Person | x not in Student implies x in Teacher
  Person in Teacher + Student
}

/* There are some classes assigned to teachers. */
pred inv5 {
  //some Teacher <: Teaches
  some Teacher.Teaches
}

/* Every teacher has classes assigned. */
pred inv6 {
  //Teacher in Teaches.Class
  //(Teaches.Class & Teacher) = Teacher
  iden & Teacher->Teacher in Teaches.~Teaches
}

/* Every class has teachers assigned. */
pred inv7 {
  //all c : Class | some t : Teacher | t->c in Teaches
  Class in Teacher.Teaches
}

/* Teachers are assigned at most one class. */
pred inv8 {
  //all t : Teacher | lone t.Teaches
  ~(Teacher<:Teaches).(Teacher<:Teaches) in iden
}

/* No class has more than a teacher assigned. */
pred inv9 {
  // Existe a possibilidade de Students em Teaches
  //all c : Class | lone (Teaches.c & Teacher)
  Teaches.~Teaches & Teacher->Teacher in iden
}

/* For every class, every student has a group assigned. */
pred inv10 {
  // Testo se todos os estudantes (Student) estão contidos nos grupos de todas as classes. E tenho q garantir para todas, daí all c : Class
  all c : Class | Student in c.Groups.Group
}

/* A class only has groups if it has a teacher assigned. */
pred inv11 {
  //all c: Class | no (c.Groups) or some Teacher & Teaches.c
  Groups.Group.Person in Teacher.Teaches //otarice Groups:(Class, (Person, Group))
}

/* Each teacher is responsible for some groups. */
pred inv12 {
  //all t : Teacher | some t.Teaches.Groups
  Teacher in Teaches.(Groups.Group.Person)
}

/* Only teachers tutor, and only students are tutored. */
pred inv13 {
  //Teacher.Tutors in Student and Tutors.Person in Teacher
  Tutors in Teacher->Student
}

/* Every student in a class is at least tutored by all the teachers
 * assigned to that class. */
pred inv14 {
  all c : Class | (Teaches.c & Teacher)->(c.Groups.Group & Student) in Tutors
}

/* The tutoring chain of every person eventually reaches a Teacher. */
pred inv15 {
  all p : Person | some (^Tutors.p & Teacher)
}
