import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: '/pubs',
    name: 'Pubs',
    component: () => import('../views/Pubs.vue')
  },
  {
    path: '/pubs/:id',
    name: 'Pub',
    component: () => import('../views/Pub.vue')
  },
  {
    path: '/authors',
    name: 'Authors',
    component: () => import('../views/Authors.vue')
  },
  {
    path: '/authors/:id',
    name: 'Author',
    component: () => import('../views/Author.vue')
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
