import Vue from "vue";

import VueRouter from "vue-router";

import Users from "../views/Users.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/users",

    name: "Users",

    component: Users,
  },

  {
    path: "/repos",

    name: "Repos",

    // route level code-splitting

    // this generates a separate chunk (about.[hash].js) for this route

    // which is lazy-loaded when the route is visited.

    component: () =>
      import(/* webpackChunkName: "about" */ "../views/Repos.vue"),
  },

  {
    path: "/repos/:idRepo",

    name: "Repo",

    component: () => import("../views/Repo.vue"),
  },
];

const router = new VueRouter({
  mode: "history",

  base: process.env.BASE_URL,

  routes,
});

export default router;
