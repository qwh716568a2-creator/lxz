import Vue from 'vue';
//閰嶇疆璺敱
import VueRouter from 'vue-router'
Vue.use(VueRouter);
//1.鍒涘缓缁勪欢
import Index from '@/views/index'
import Home from '@/views/home'
import Login from '@/views/login'
import NotFound from '@/views/404'
import UpdatePassword from '@/views/update-password'
import pay from '@/views/pay'
import register from '@/views/register'
import center from '@/views/center'

         import users from '@/views/modules/users/list'
        import dictionary from '@/views/modules/dictionary/list'
        import exampaper from '@/views/modules/exampaper/list'
        import examquestion from '@/views/modules/examquestion/list'
        import examrecord from '@/views/modules/examrecord/list'
        import examredetails from '@/views/modules/examredetails/list'
        import analysis from '@/views/modules/analysis/list'
        import yonghu from '@/views/modules/yonghu/list'
        import dictionaryExampaper from '@/views/modules/dictionaryExampaper/list'
        import dictionaryExamquestion from '@/views/modules/dictionaryExamquestion/list'
        import dictionaryExamredetails from '@/views/modules/dictionaryExamredetails/list'
        import dictionarySex from '@/views/modules/dictionarySex/list'





//2.閰嶇疆璺敱   娉ㄦ剰锛氬悕瀛?
const routes = [{
    path: '/index',
    name: '棣栭〉',
    component: Index,
    children: [{
      // 杩欓噷涓嶈缃€硷紝鏄妸main浣滀负榛樿椤甸潰
      path: '/',
      name: '棣栭〉',
      component: Home,
      meta: {icon:'', title:'center'}
    }, {
      path: '/updatePassword',
      name: '淇敼瀵嗙爜',
      component: UpdatePassword,
      meta: {icon:'', title:'updatePassword'}
    }, {
      path: '/pay',
      name: '鏀粯',
      component: pay,
      meta: {icon:'', title:'pay'}
    }, {
      path: '/center',
      name: '涓汉淇℃伅',
      component: center,
      meta: {icon:'', title:'center'}
    } ,{
        path: '/users',
        name: '绠＄悊淇℃伅',
        component: users
      }
    ,{
        path: '/dictionaryExampaper',
        name: '闂嵎鐘舵€?,
        component: dictionaryExampaper
    }
    ,{
        path: '/dictionaryExamquestion',
        name: '棰樼洰绫诲瀷',
        component: dictionaryExamquestion
    }
    ,{
        path: '/dictionaryExamredetails',
        name: '瀹℃牳缁撴灉',
        component: dictionaryExamredetails
    }
    ,{
        path: '/dictionarySex',
        name: '鎬у埆',
        component: dictionarySex
    }


    ,{
        path: '/dictionary',
        name: '瀛楀吀琛?,
        component: dictionary
      }
    ,{
        path: '/exampaper',
        name: '闂嵎琛?,
        component: exampaper
      }
    ,{
        path: '/examquestion',
        name: '棰樼洰琛?,
        component: examquestion
      }
    ,{
        path: '/examrecord',
        name: '闂嵎璋冩煡璁板綍琛?,
        component: examrecord
      }
    ,{
        path: '/analysis',
        name: '数据分析',
        component: analysis
      }
    ,{
        path: '/examredetails',
        name: '绛旈璇︽儏琛?,
        component: examredetails
      }
    ,{
        path: '/yonghu',
        name: '鐢ㄦ埛',
        component: yonghu
      }


    ]
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: {icon:'', title:'login'}
  },
  {
    path: '/register',
    name: 'register',
    component: register,
    meta: {icon:'', title:'register'}
  },
  {
    path: '/',
    name: '棣栭〉',
    redirect: '/index'
  }, /*榛樿璺宠浆璺敱*/
  {
    path: '*',
    component: NotFound
  }
]
//3.瀹炰緥鍖朧ueRouter  娉ㄦ剰锛氬悕瀛?
const router = new VueRouter({
  mode: 'hash',
  /*hash妯″紡鏀逛负history*/
  routes // 锛堢缉鍐欙級鐩稿綋浜?routes: routes
})

export default router;
