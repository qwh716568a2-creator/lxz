var projectName = '\u901a\u7528\u95ee\u5377\u8c03\u67e5\u7cfb\u7edf';

var swiper = {
    width: '100%',
    height: '400px',
    arrow: 'none',
    anim: 'default',
    interval: 2000,
    indicator: 'outside'
};

var centerMenu = [
    {
        name: '\u4e2a\u4eba\u4e2d\u5fc3',
        url: '../' + localStorage.getItem('userTable') + '/center.html'
    },
    {
        name: '\u95ee\u5377\u8c03\u67e5\u8bb0\u5f55',
        url: '../examrecord/list.html'
    }
];

var indexNav = [
    {
        name: '\u95ee\u5377\u5217\u8868',
        url: './pages/exampaper/list.html?v=public-link-20260523'
    }
];

var adminurl = 'http://localhost:8080/tongyongwenjuandiaocha/admin/dist/index.html#/login';

var menu = [
    {
        tableName: 'users',
        roleName: '\u7ba1\u7406\u5458',
        hasBackLogin: '\u662f',
        hasBackRegister: '\u5426',
        hasFrontLogin: '\u5426',
        hasFrontRegister: '\u5426',
        backMenu: [],
        frontMenu: []
    },
    {
        tableName: 'yonghu',
        roleName: '\u7528\u6237',
        hasBackLogin: '\u5426',
        hasBackRegister: '\u5426',
        hasFrontLogin: '\u662f',
        hasFrontRegister: '\u662f',
        backMenu: [],
        frontMenu: [
            {
                menu: '\u95ee\u5377\u5217\u8868',
                child: [
                    {
                        menu: '\u95ee\u5377\u5217\u8868',
                        menuJump: '\u5217\u8868',
                        tableName: 'exampaper',
                        buttons: ['\u67e5\u770b', '\u95ee\u5377\u8c03\u67e5']
                    }
                ]
            }
        ]
    }
];

var isAuth = function () {
    return true;
};

var isFrontAuth = function () {
    return true;
};
