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
  all x : Person | x in Student
}

/* There are no teachers. */
pred inv2 {
  all x : Person | x not in Teacher
}

/* No person is both a student and a teacher. */
pred inv3 {
  all x,y : Person | x in Student and y in Teacher implies x not in Teacher and y not in Student
}

/* No person is neither a student nor a teacher. */
pred inv4 {
  all x : Person | x not in Student implies x in Teacher
}

/* There classes assigned to teachers. */
pred inv5 {
  some t : Teacher | some c : Class | t->c in Teaches
}

/* Every teacher has classes assigned. */
pred inv6 {
  all t : Teacher | some c : Class | t->c in Teaches
}

/* Every class has teachers assigned. */
pred inv7 {
  // all x : Class | some p : Person, g : Group . x->p->g in Group implies some t : Teacher | t->x in Teacher
  all c : Class | some t : Teacher | t->c in Teaches
}

/* Teachers are assigned at most one class. */
pred inv8 {
  all t : Teacher, c1,c2 : Class | t->c1 in Teaches and t->c2 in Teaches implies c1=c2
}

/* No class has more than a teacher assigned. */
pred inv9 {
  all c : Class | all t1,t2 : Teacher | t1->c in Teaches and t2->c in Teaches implies t1=t2
}

/* For every class, every student has a group assigned. */
pred inv10 {
  all c : Class | all s : Student | some g : Group | c->s->g in Groups
}

/* A class only has groups if it has a teacher assigned. */
pred inv11 {
  all c : Class | all g : Group, p : Person | c->p->g in Groups implies some t : Teacher | t->c in Teaches
}

/* Each teacher is responsible for some groups. */
pred inv12 {
  // Aqui o termo de relação é a class c e não o teacher, como tinha pensado.
  all t: Teacher | some c: Class, g: Group, p: Person | c->p->g in Groups and t->c in Teaches
}

/* Only teachers tutor, and only students are tutored. */
pred inv13 {
  all p1,p2 : Person | p1->p2 in Tutors implies p1 in Teacher and p2 in Student
}

/* Every student in a class is at least tutored by the teachers
 * assigned to that class. */
pred inv14 {
  all ps : Person, t : /*Teacher*/ Person | all c : Class, g : Group | c->ps->g in Groups and t->c in Teaches implies t->ps in Tutors
}

/* Assuming a universe of 3 persons, the tutoring chain of every
 * person eventually reaches a Teacher. */
pred inv15 {

}


