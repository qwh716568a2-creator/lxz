







<template>
    <div class="main-content">

        <!-- 鏉′欢鏌ヨ -->
        <div v-if="showFlag">
            <el-form :inline="true" :model="searchForm" class="form-content">
                <el-row :gutter="20" class="slt" :style="{justifyContent:contents.searchBoxPosition=='1'?'flex-start':contents.searchBoxPosition=='2'?'center':'flex-end'}">
                                                        


                    <el-form-item>
                        <el-button type="success" @click="search()">鏌ヨ<i class="el-icon-search el-icon--right"/></el-button>
                    </el-form-item>
                </el-row>
                <el-row class="ad" :style="{justifyContent:contents.btnAdAllBoxPosition=='1'?'flex-start':contents.btnAdAllBoxPosition=='2'?'center':'flex-end'}">
                    <el-form-item>
                        <el-button
                                v-if="isAuth('dictionary','鏂板')"
                                type="success"
                                icon="el-icon-plus"
                                @click="addOrUpdateHandler()"
                        >鏂板</el-button>
                        &nbsp;
                        <el-button
                                v-if="isAuth('dictionary','鍒犻櫎')"
                                :disabled="dataListSelections.length <= 0"
                                type="danger"
                                icon="el-icon-delete"
                                @click="deleteHandler()"
                        >鍒犻櫎</el-button>
                        &nbsp;
                        <el-button
                                v-if="isAuth('dictionary','鎶ヨ〃')"
                                type="success"
                                icon="el-icon-pie-chart"
                                @click="chartDialog()"
                        >鎶ヨ〃</el-button>
                        &nbsp;
                        <a style="text-decoration:none" class="el-button el-button--success"
                           v-if="isAuth('dictionary','瀵煎叆瀵煎嚭')"
                           icon="el-icon-download"
                           href="http://localhost:8080/tongyongwenjuandiaocha/upload/dictionaryMuBan.xls"
                        >鎵归噺瀵煎叆瀛楀吀琛ㄦ暟鎹ā鏉?/a>
                        &nbsp;
                        <el-upload
                                v-if="isAuth('dictionary','瀵煎叆瀵煎嚭')"
                                style="display: inline-block"
                                action="tongyongwenjuandiaocha/file/upload"
                                :on-success="dictionaryUploadSuccess"
                                :on-error="dictionaryUploadError"
                                :show-file-list = false>
                            <el-button
                                    v-if="isAuth('dictionary','瀵煎叆瀵煎嚭')"
                                    type="success"
                                    icon="el-icon-upload2"
                            >鎵归噺瀵煎叆瀛楀吀琛ㄦ暟鎹?/el-button>
                        </el-upload>
                        &nbsp;
                        <!-- 瀵煎嚭excel -->
                        <download-excel v-if="isAuth('dictionary','瀵煎叆瀵煎嚭')" style="display: inline-block" class = "export-excel-wrapper" :data = "dataList" :fields = "json_fields" name = "dictionary.xls">
                            <!-- 瀵煎嚭excel -->
                            <el-button
                                    type="success"
                                    icon="el-icon-download"
                            >瀵煎嚭</el-button>
                        </download-excel>
                        &nbsp;
                    </el-form-item>
                </el-row>
            </el-form>
            <div class="table-content">
                <el-table class="tables" :size="contents.tableSize" :show-header="contents.tableShowHeader"
                          :header-row-style="headerRowStyle" :header-cell-style="headerCellStyle"
                          :border="contents.tableBorder"
                          :fit="contents.tableFit"
                          :stripe="contents.tableStripe"
                          :row-style="rowStyle"
                          :cell-style="cellStyle"
                          :style="{width: '100%',fontSize:contents.tableContentFontSize,color:contents.tableContentFontColor}"
                          v-if="isAuth('dictionary','鏌ョ湅')"
                          :data="dataList"
                          v-loading="dataListLoading"
                          @selection-change="selectionChangeHandler">
                    <el-table-column  v-if="contents.tableSelection"
                                      type="selection"
                                      header-align="center"
                                      align="center"
                                      width="50">
                    </el-table-column>
                    <el-table-column label="绱㈠紩" v-if="contents.tableIndex" type="index" width="50" />
                    <el-table-column  :sortable="contents.tableSortable" :align="contents.tableAlign"
                                      prop="codeIndex"
                                      header-align="center"
                                      label="缂栫爜">
                        <template slot-scope="scope">
                            {{scope.row.codeIndex}}
                        </template>
                    </el-table-column>
                    <el-table-column  :sortable="contents.tableSortable" :align="contents.tableAlign"
                                      prop="indexName"
                                      header-align="center"
                                      label="绫诲瀷">
                        <template slot-scope="scope">
                            {{scope.row.indexName}}
                        </template>
                    </el-table-column>

                    <el-table-column width="300" :align="contents.tableAlign"
                                     header-align="center"
                                     label="鎿嶄綔">
                        <template slot-scope="scope">
                            <el-button v-if="isAuth('dictionary','鏌ョ湅')" type="success" icon="el-icon-tickets" size="mini" @click="addOrUpdateHandler(scope.row.id,'info')">{{ contents.tableBtnFont == 1?'璇︽儏':'' }}</el-button>
                            <el-button v-if="isAuth('dictionary','淇敼')" type="primary" icon="el-icon-edit" size="mini" @click="addOrUpdateHandler(scope.row.id)">{{ contents.tableBtnFont == 1?'淇敼':'' }}</el-button>
                            <el-button v-if="isAuth('dictionary','鍒犻櫎')" type="danger" icon="el-icon-delete" size="mini" @click="deleteHandler(scope.row.id)">{{ contents.tableBtnFont == 1?'鍒犻櫎':'' }}</el-button>

                        </template>
                    </el-table-column>
                </el-table>
                <el-pagination
                        clsss="pages"
                        :layout="layouts"
                        @size-change="sizeChangeHandle"
                        @current-change="currentChangeHandle"
                        :current-page="pageIndex"
                        :page-sizes="[10, 20, 50, 100]"
                        :page-size="Number(contents.pageEachNum)"
                        :total="totalPage"
                        :small="contents.pageStyle"
                        class="pagination-content"
                        :background="contents.pageBtnBG"
                        :style="{textAlign:contents.pagePosition==1?'left':contents.pagePosition==2?'center':'right'}"
                ></el-pagination>
            </div>
        </div>
        <!-- 娣诲姞/淇敼椤甸潰  灏嗙埗缁勪欢鐨剆earch鏂规硶浼犻€掔粰瀛愮粍浠?->
        <add-or-update v-if="addOrUpdateFlag" :parent="this" ref="addOrUpdate"></add-or-update>



        <el-dialog title="缁熻鎶ヨ〃" :visible.sync="chartVisiable" width="800">
            <el-date-picker
                    v-model="echartsDate"
                    type="year"
                    placeholder="閫夋嫨骞?>
            </el-date-picker>
            <el-button @click="chartDialog()">鏌ヨ</el-button>
            <div id="statistic" style="width:100%;height:600px;"></div>
            <span slot="footer" class="dialog-footer">
				<el-button @click="chartVisiable = false">杩斿洖</el-button>
			</span>
        </el-dialog>

    </div>
</template>
<script>
    import AddOrUpdate from "./add-or-update";
    import styleJs from "../../../utils/style.js";
    export default {
        data() {
        return {
            searchForm: {
                key: ""
            },
            sessionTable : "",//鐧诲綍璐︽埛鎵€鍦ㄨ〃鍚?
            role : "",//鏉冮檺
    //绾ц仈琛ㄤ笅鎷夋鎼滅储鏉′欢
    //褰撳墠琛ㄤ笅鎷夋鎼滅储鏉′欢
            form:{
                id : null,
                dicCode : null,
                dicName : null,
                codeIndex : null,
                indexName : null,
                superTypes : null,
                createTime : null,
            },
            dataList: [],
            pageIndex: 1,
            pageSize: 10,
            totalPage: 0,
            dataListLoading: false,
            dataListSelections: [],
            showFlag: true,
            sfshVisiable: false,
            shForm: {},
            chartVisiable: false,
            addOrUpdateFlag:false,
            contents:null,
            layouts: '',

            echartsDate: new Date(),//echarts鐨勬椂闂存煡璇㈠瓧娈?



            //瀵煎嚭excel
            json_fields: {
                //绾ц仈琛ㄥ瓧娈?
                //鏈〃瀛楁
                     '瀛楁': "dicCode",
                     '瀛楁鍚?: "dicName",
                     '缂栫爜': "codeIndex",
                     '缂栫爜鍚嶅瓧': "indexName",
                     '鐖跺瓧娈礽d': "superTypes",
            },

            };
        },
        created() {
            this.contents = styleJs.listStyle();
            this.init();
            this.getDataList();
            this.contentStyleChange()
        },
        mounted() {
            //鑾峰彇褰撳墠鐧诲綍鐢ㄦ埛鐨勪俊鎭?
            this.sessionTable = this.$storage.get("sessionTable");
            this.role = this.$storage.get("role");

        },
        filters: {
            htmlfilter: function (val) {
                return val.replace(/<[^>]*>/g).replace(/undefined/g,'');
            }
        },
        components: {
            AddOrUpdate,
        },
        computed: {
        },
        methods: {
            chartDialog() {
                let _this = this;
                let params = {
                    dateFormat :"%Y"
                    ,riqi :_this.echartsDate.getFullYear()
                    ,thisTable : {//褰撳墠琛?
                        tableName :"shangdian_shouyin"//褰撳墠琛ㄨ〃鍚?
                        ,sumColum : 'shangdian_shouyin_true_price' //姹傚拰瀛楁
                        ,date : 'insert_time'//鍒嗙粍鏃ユ湡瀛楁
                        // ,string : 'name,leixing'//鍒嗙粍瀛楃涓插瓧娈?
                        // ,types : 'shangdian_shouyin_types'//鍒嗙粍涓嬫媺妗嗗瓧娈?
                    }
                    // ,joinTable : {//绾ц仈琛紙鍙互涓嶅瓨鍦級
                    //     tableName :"yuangong"//绾ц仈琛ㄨ〃鍚?
                    //     // ,date : 'insert_time'//鍒嗙粍鏃ユ湡瀛楁
                    //     ,string : 'yuangong_name'//鍒嗙粍瀛楃涓插瓧娈?
                    //     // ,types : 'insertTime'//鍒嗙粍涓嬫媺妗嗗瓧娈?
                    // }
                }
                _this.chartVisiable = true;
                _this.$nextTick(() => {
                    var statistic = this.$echarts.init(document.getElementById("statistic"), 'macarons');
                    this.$http({
                        url: "barSum",
                        method: "get",
                        params: params
                    }).then(({data}) => {
                        if(data && data.code === 0){


                            //鏌辩姸鍥?姹傚拰 宸叉垚鍔熶娇鐢?
                            //start
                            let series = [];//鍏蜂綋鏁版嵁鍊?
                            data.data.yAxis.forEach(function (item,index) {
                                let tempMap = {};
                                tempMap.name=data.data.legend[index];
                                tempMap.type='bar';
                                tempMap.data=item;
                                series.push(tempMap);

                            })

                            var option = {
                                tooltip: {
                                    trigger: 'axis',
                                    axisPointer: {
                                        type: 'cross',
                                        crossStyle: {
                                            color: '#999'
                                        }
                                    }
                                },
                                toolbox: {
                                    feature: {
                                        // dataView: { show: true, readOnly: false },  // 鏁版嵁鏌ョ湅
                                        magicType: { show: true, type: ['line', 'bar'] },//鍒囨崲鍥惧舰灞曠ず鏂瑰紡
                                        // restore: { show: true }, // 鍒锋柊
                                        saveAsImage: { show: true }//淇濆瓨
                                    }
                                },
                                legend: {
                                    data: data.data.legend//鏍囬  鍙互鐐瑰嚮瀵艰嚧鏌愪竴鍒楁暟鎹秷澶?
                                },
                                xAxis: [
                                    {
                                        type: 'category',
                                        name: '鏈堜唤',
                                        data: data.data.xAxis,
                                        axisPointer: {
                                            type: 'shadow'
                                        }
                                    }
                                ],
                                yAxis: [
                                    {
                                        type: 'value',//涓嶈兘鏀?
                                        name: '鍏?,//y杞村崟浣?
                                        axisLabel: {
                                            formatter: '{value} 鍏? // 鍚庣紑
                                        }
                                    }
                                ],
                                series:series//鍏蜂綋鏁版嵁
                            };
                            // 浣跨敤鍒氭寚瀹氱殑閰嶇疆椤瑰拰鏁版嵁鏄剧ず鍥捐〃銆?
                            statistic.setOption(option);
                            //鏍规嵁绐楀彛鐨勫ぇ灏忓彉鍔ㄥ浘琛?
                            window.onresize = function () {
                                statistic.resize();
                            };
                            //end



                            //楗肩姸鍥?鍘熷厛鑷甫鐨?鏈慨鏀硅繃
                            //start
                            /*let res = data.data;
                            let xAxis = [];
                            let yAxis = [];
                            let pArray = []
                            for (let i = 0; i < res.length; i++) {
                                xAxis.push(res[i].xinzi);
                                yAxis.push(res[i].total);
                                pArray.push({
                                    value: res[i].total,
                                    name: res[i].xinzi
                                })
                                var option = {};
                                option = {
                                    title: {
                                        text: '缁熻',
                                        left: 'center'
                                    },
                                    tooltip: {
                                        trigger: 'item',
                                        formatter: '{b} : {c} ({d}%)'
                                    },
                                    series: [{
                                        type: 'pie',
                                        radius: '55%',
                                        center: ['50%', '60%'],
                                        data: pArray,
                                        emphasis: {
                                            itemStyle: {
                                                shadowBlur: 10,
                                                shadowOffsetX: 0,
                                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                                            }
                                        }
                                    }]
                                };
                                // 浣跨敤鍒氭寚瀹氱殑閰嶇疆椤瑰拰鏁版嵁鏄剧ず鍥捐〃銆?
                                statistic.setOption(option);
                                //鏍规嵁绐楀彛鐨勫ぇ灏忓彉鍔ㄥ浘琛?
                                window.onresize = function () {
                                    statistic.resize();
                                };
                            }*/

                            //end
                        }else {
                            this.$message({
                                message: "鎶ヨ〃鏈煡璇㈠埌鏁版嵁",
                                type: "success",
                                duration: 1500,
                                onClose: () => {
                                    this.search();
                                }
                            });
                        }
                    });
                });
                this.chartVisiable = !this.chartVisiable;
                this.$nextTick(() => {
                    var statistic = this.$echarts.init(document.getElementById("statistic"), 'macarons');
                    this.$http({
                        url: "group/xinzitongji/xinzi",
                        method: "get",
                    }).then(({data}) => {
                        if(data && data.code === 0){
                            let res = data.data;
                            let xAxis = [];
                            let yAxis = [];
                            let pArray = []
                            for (let i = 0; i < res.length; i++) {
                                xAxis.push(res[i].xinzi);
                                yAxis.push(res[i].total);
                                pArray.push({
                                    value: res[i].total,
                                    name: res[i].xinzi
                                })
                                var option = {};
                                option = {
                                    title: {
                                        text: '缁熻',
                                        left: 'center'
                                    },
                                    tooltip: {
                                        trigger: 'item',
                                        formatter: '{b} : {c} ({d}%)'
                                    },
                                    series: [{
                                        type: 'pie',
                                        radius: '55%',
                                        center: ['50%', '60%'],
                                        data: pArray,
                                        emphasis: {
                                            itemStyle: {
                                                shadowBlur: 10,
                                                shadowOffsetX: 0,
                                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                                            }
                                        }
                                    }]
                                };
                                // 浣跨敤鍒氭寚瀹氱殑閰嶇疆椤瑰拰鏁版嵁鏄剧ず鍥捐〃銆?
                                statistic.setOption(option);
                                //鏍规嵁绐楀彛鐨勫ぇ灏忓彉鍔ㄥ浘琛?
                                window.onresize = function () {
                                    statistic.resize();
                                };
                            }
                        }
                    });
                // xcolumn ycolumn
                });
            },
            contentStyleChange() {
                this.contentSearchStyleChange()
                this.contentBtnAdAllStyleChange()
                this.contentSearchBtnStyleChange()
                this.contentTableBtnStyleChange()
                this.contentPageStyleChange()
            },
            contentSearchStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .slt .el-input__inner').forEach(el => {
                        let textAlign = 'left'
                        if(this.contents.inputFontPosition == 2)
                            textAlign = 'center'
                            if (this.contents.inputFontPosition == 3) textAlign = 'right'
                                el.style.textAlign = textAlign
                            el.style.height = this.contents.inputHeight
                            el.style.lineHeight = this.contents.inputHeight
                            el.style.color = this.contents.inputFontColor
                            el.style.fontSize = this.contents.inputFontSize
                            el.style.borderWidth = this.contents.inputBorderWidth
                            el.style.borderStyle = this.contents.inputBorderStyle
                            el.style.borderColor = this.contents.inputBorderColor
                            el.style.borderRadius = this.contents.inputBorderRadius
                            el.style.backgroundColor = this.contents.inputBgColor
                    })
                    if (this.contents.inputTitle) {
                        document.querySelectorAll('.form-content .slt .el-form-item__label').forEach(el => {
                            el.style.color = this.contents.inputTitleColor
                            el.style.fontSize = this.contents.inputTitleSize
                            el.style.lineHeight = this.contents.inputHeight
                        })
                    }
                    setTimeout(() => {
                        document.querySelectorAll('.form-content .slt .el-input__prefix').forEach(el => {
                            el.style.color = this.contents.inputIconColor
                            el.style.lineHeight = this.contents.inputHeight
                        })
                        document.querySelectorAll('.form-content .slt .el-input__suffix').forEach(el => {
                            el.style.color = this.contents.inputIconColor
                            el.style.lineHeight = this.contents.inputHeight
                        })
                        document.querySelectorAll('.form-content .slt .el-input__icon').forEach(el => {
                            el.style.lineHeight = this.contents.inputHeight
                        })
                    }, 10 )
                })
            },
            // 鎼滅储鎸夐挳
            contentSearchBtnStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .slt .el-button--success').forEach(el => {
                        el.style.height = this.contents.searchBtnHeight
                        el.style.color = this.contents.searchBtnFontColor
                        el.style.fontSize = this.contents.searchBtnFontSize
                        el.style.borderWidth = this.contents.searchBtnBorderWidth
                        el.style.borderStyle = this.contents.searchBtnBorderStyle
                        el.style.borderColor = this.contents.searchBtnBorderColor
                        el.style.borderRadius = this.contents.searchBtnBorderRadius
                        el.style.backgroundColor = this.contents.searchBtnBgColor
                    })
                })
            },
            // 鏂板銆佹壒閲忓垹闄?
            contentBtnAdAllStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .ad .el-button--success').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllAddFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllAddBgColor
                    })
                    document.querySelectorAll('.form-content .ad .el-button--danger').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllDelFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllDelBgColor
                    })
                    document.querySelectorAll('.form-content .ad .el-button--warning').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllWarnFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllWarnBgColor
                    })
                })
            },
            // 琛ㄦ牸
            rowStyle({row, rowIndex}) {
                if (rowIndex % 2 == 1) {
                    if (this.contents.tableStripe) {
                        return {color: this.contents.tableStripeFontColor}
                    }
                } else {
                    return ''
                }
            },
            cellStyle({row, rowIndex}) {
                if (rowIndex % 2 == 1) {
                    if (this.contents.tableStripe) {
                        return {backgroundColor: this.contents.tableStripeBgColor}
                    }
                } else {
                    return ''
                }
            },
            headerRowStyle({row, rowIndex}) {
                return {color: this.contents.tableHeaderFontColor}
            },
            headerCellStyle({row, rowIndex}) {
                return {backgroundColor: this.contents.tableHeaderBgColor}
            },
            // 琛ㄦ牸鎸夐挳
            contentTableBtnStyleChange() {
                // this.$nextTick(()=>{
                //   setTimeout(()=>{
                //     document.querySelectorAll('.table-content .tables .el-table__body .el-button--success').forEach(el=>{
                //       el.style.height = this.contents.tableBtnHeight
                //       el.style.color = this.contents.tableBtnDetailFontColor
                //       el.style.fontSize = this.contents.tableBtnFontSize
                //       el.style.borderWidth = this.contents.tableBtnBorderWidth
                //       el.style.borderStyle = this.contents.tableBtnBorderStyle
                //       el.style.borderColor = this.contents.tableBtnBorderColor
                //       el.style.borderRadius = this.contents.tableBtnBorderRadius
                //       el.style.backgroundColor = this.contents.tableBtnDetailBgColor
                //     })
                //     document.querySelectorAll('.table-content .tables .el-table__body .el-button--primary').forEach(el=>{
                //       el.style.height = this.contents.tableBtnHeight
                //       el.style.color = this.contents.tableBtnEditFontColor
                //       el.style.fontSize = this.contents.tableBtnFontSize
                //       el.style.borderWidth = this.contents.tableBtnBorderWidth
                //       el.style.borderStyle = this.contents.tableBtnBorderStyle
                //       el.style.borderColor = this.contents.tableBtnBorderColor
                //       el.style.borderRadius = this.contents.tableBtnBorderRadius
                //       el.style.backgroundColor = this.contents.tableBtnEditBgColor
                //     })
                //     document.querySelectorAll('.table-content .tables .el-table__body .el-button--danger').forEach(el=>{
                //       el.style.height = this.contents.tableBtnHeight
                //       el.style.color = this.contents.tableBtnDelFontColor
                //       el.style.fontSize = this.contents.tableBtnFontSize
                //       el.style.borderWidth = this.contents.tableBtnBorderWidth
                //       el.style.borderStyle = this.contents.tableBtnBorderStyle
                //       el.style.borderColor = this.contents.tableBtnBorderColor
                //       el.style.borderRadius = this.contents.tableBtnBorderRadius
                //       el.style.backgroundColor = this.contents.tableBtnDelBgColor
                //     })

                //   }, 50)
                // })
            },
            // 鍒嗛〉
            contentPageStyleChange() {
                let arr = []
                if (this.contents.pageTotal) arr.push('total')
                if (this.contents.pageSizes) arr.push('sizes')
                if (this.contents.pagePrevNext) {
                    arr.push('prev')
                    if (this.contents.pagePager) arr.push('pager')
                    arr.push('next')
                }
                if (this.contents.pageJumper) arr.push('jumper')
                this.layouts = arr.join()
                this.contents.pageEachNum = 10
            },

            init() {
            },
            search() {
                this.pageIndex = 1;
                this.getDataList();
            },
            // 鑾峰彇鏁版嵁鍒楄〃
            getDataList() {
                this.dataListLoading = true;
                let params = {
                    page: this.pageIndex,
                    limit: this.pageSize,
                    sort: 'id',
                }

                                                        
                params['dictionaryDelete'] = 1// 閫昏緫鍒犻櫎瀛楁 1 鏈垹闄?2 鍒犻櫎


                this.$http({
                    url: "dictionary/page",
                    method: "get",
                    params: params
                }).then(({data}) => {
                    if(data && data.code === 0){
                        this.dataList = data.data.list;
                        this.totalPage = data.data.total;
                    }else{
                        this.dataList = [];
                        this.totalPage = 0;
                    }
                    this.dataListLoading = false;
                });

                //鏌ヨ绾ц仈琛ㄦ悳绱㈡潯浠舵墍鏈夊垪琛?
                //鏌ヨ褰撳墠琛ㄦ悳绱㈡潯浠舵墍鏈夊垪琛?
            },
            //姣忛〉鏁?
            sizeChangeHandle(val) {
                this.pageSize = val;
                this.pageIndex = 1;
                this.getDataList();
            },
            // 褰撳墠椤?
            currentChangeHandle(val) {
                this.pageIndex = val;
                this.getDataList();
            },
            // 澶氶€?
            selectionChangeHandler(val) {
                this.dataListSelections = val;
            },
            // 娣诲姞/淇敼
            addOrUpdateHandler(id, type) {
                this.showFlag = false;
                this.addOrUpdateFlag = true;
                this.crossAddOrUpdateFlag = false;
                if (type != 'info') {
                    type = 'else';
                }
                this.$nextTick(() => {
                    this.$refs.addOrUpdate.init(id, type);
                });
            },
            // 涓嬭浇
            download(file) {
                window.open(" ${file} ")
            },
            // 鍒犻櫎
            deleteHandler(id) {
                var ids = id ? [Number(id)] : this.dataListSelections.map(item => {
                    return Number(item.id);
                });

                this.$confirm(`纭畾杩涜[${id ? "鍒犻櫎" : "鎵归噺鍒犻櫎"}]鎿嶄綔?`, "鎻愮ず", {
                    confirmButtonText: "纭畾",
                    cancelButtonText: "鍙栨秷",
                    type: "warning"
                }).then(() => {
                    this.$http({
                        url: "dictionary/delete",
                        method: "post",
                        data: ids
                    }).then(({data}) => {
                        if(data && data.code === 0){
                            this.$message({
                                message: "鎿嶄綔鎴愬姛",
                                type: "success",
                                duration: 1500,
                                onClose: () => {
                                    this.search();
                                }
                            });
                        }else{
                            this.$message.error(data.msg);
                        }
                    });
                });
            },
            // 瀵煎叆鍔熻兘涓婁紶鏂囦欢鎴愬姛鍚庤皟鐢ㄥ鍏ユ柟娉?
            dictionaryUploadSuccess(data){
                let _this = this;
                _this.$http({
                    url: "dictionary/batchInsert?fileName=" + data.file,
                    method: "get"
                }).then(({data}) => {
                    if(data && data.code === 0){
                        _this.$message({
                            message: "瀵煎叆瀛楀吀琛ㄦ暟鎹垚鍔?,
                            type: "success",
                            duration: 1500,
                            onClose: () => {
                                _this.search();
                            }
                        });
                    }else{
                        _this.$message.error(data.msg);
                    }
                });

            },
            // 瀵煎叆鍔熻兘涓婁紶鏂囦欢澶辫触鍚庤皟鐢ㄥ鍏ユ柟娉?
            dictionaryUploadError(data){
                this.$message.error('涓婁紶澶辫触');
            },

        }
    };
</script>
<style lang="scss" scoped>
.slt {
    margin: 0 !important;
    display: flex;
  }

  .ad {
    margin: 0 !important;
    display: flex;
  }

  .pages {
    & /deep/ el-pagination__sizes{
      & /deep/ el-input__inner {
        height: 22px;
        line-height: 22px;
      }
    }
  }
  

  .el-button+.el-button {
    margin:0;
  } 

  .tables {
	& /deep/ .el-button--success {
		height: 40px;
		color: #333;
		font-size: 14px;
		border-width: 1px;
		border-style: solid;
		border-color: #DCDFE6;
		border-radius: 4px;
		background-color: rgba(117, 113, 249, 1);
	}
	
	& /deep/ .el-button--primary {
		height: 40px;
		color: #333;
		font-size: 14px;
		border-width: 1px;
		border-style: solid;
		border-color: #DCDFE6;
		border-radius: 4px;
		background-color: rgba(102, 204, 255, 1);
	}
	
	& /deep/ .el-button--danger {
		height: 40px;
		color: #333;
		font-size: 14px;
		border-width: 1px;
		border-style: solid;
		border-color: #DCDFE6;
		border-radius: 4px;
		background-color: rgba(204, 255, 102, 1);
	}

    & /deep/ .el-button {
      margin: 4px;
    }
  }
</style>


