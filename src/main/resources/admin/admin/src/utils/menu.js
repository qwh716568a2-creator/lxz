








const menu = {
    list() {
        return [
    {
        "backMenu":[
            {
                "child":[
                    {
                        "buttons":[
                            "查看",
                            "新增",
                            "修改",
                            "删除"
                        ],
                        "menu":"管理员管理",
                        "menuJump":"列表",
                        "tableName":"users"
                    }
                ],
                "menu":"管理员管理"
            }
            ,{
                "child":[
                    {
                        "buttons":[
                            "查看",
                            "新增",
                            "修改",
                            "删除"
                        ],
                        "menu":"用户管理",
                        "menuJump":"列表",
                        "tableName":"yonghu"
                    }
                ],
                "menu":"用户管理"
            }
            ,{
                "child":[
                    {
                        "buttons":[
                            "查看",
                            "新增",
                            "修改",
                            "删除"
                        ],
                        "menu":"问卷管理",
                        "menuJump":"列表",
                        "tableName":"exampaper"
                    }
                ],
                "menu":"问卷管理"
            }
            ,{
                "child":[
                    {
                        "buttons":[
                            "查看",
                            "删除"
                        ],
                        "menu":"问卷调查记录",
                        "menuJump":"列表",
                        "tableName":"examrecord"
                    },
                    {
                        "buttons":[
                            "查看"
                        ],
                        "menu":"数据分析",
                        "menuJump":"列表",
                        "tableName":"analysis"
                    }
                ],
                "menu":"问卷调查管理"
            }
        ],
        "frontMenu":[],
        "hasBackLogin":"是",
        "hasBackRegister":"否",
        "hasFrontLogin":"否",
        "hasFrontRegister":"否",
        "roleName":"管理员",
        "tableName":"users"
    }
,{
	    "backMenu":[
	        {
	            "child":[
	                {
	                "buttons":[
                            "查看",
                            "问卷调查"
	                    ],
	                    "menu":"问卷列表",
	                    "menuJump":"列表",
	                    "tableName":"exampaper"
	                },
	                {
	                    "buttons":[
	                        "查看"
	                    ],
	                    "menu":"问卷调查记录",
	                    "menuJump":"列表",
	                    "tableName":"examrecord"
	                }
	            ],
	            "menu":"问卷调查管理"
	        }
	    ],
        "frontMenu":[],
        "hasBackLogin":"是",
        "hasBackRegister":"否",
        "hasFrontLogin":"否",
        "hasFrontRegister":"否",
        "roleName":"用户",
        "tableName":"yonghu"
	}
]
    }
}
export default menu;
