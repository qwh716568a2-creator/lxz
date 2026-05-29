







<template>
    <div class="addEdit-block">
        <el-form
                class="detail-form-content"
                ref="ruleForm"
                :model="ruleForm"
                :rules="rules"
                label-width="80px"
                :style="{backgroundColor:addEditForm.addEditBoxColor}">
            <el-row>
                <input id="updateId" name="id" type="hidden">
               <el-col :span="12">
                   <el-form-item class="input" v-if="type!='info'"  label="问卷名称" prop="exampaperName">
                       <el-input v-model="ruleForm.exampaperName"
                                 @input="onTypoInput('paperName')"
                                 placeholder="问卷名称" clearable  :readonly="ro.exampaperName"></el-input>
                       <div v-if="fieldTypo.paperName.checking" class="typo-check-bar">
                           <span class="typo-checking">正在智能检测错别字...</span>
                       </div>
                       <div v-if="fieldTypo.paperName.issues.length > 0" class="typo-panel">
                           <div class="typo-summary">发现可疑错别字</div>
                           <div v-for="(item,index) in fieldTypo.paperName.issues" :key="index" class="typo-item">
                               {{index + 1}}. {{item.position || getIssuePosition(item)}}：{{item.original || '空内容'}}
                               <span v-if="item.suggestion" class="typo-suggestion">建议：{{item.suggestion}}</span>
                           </div>
                       </div>
                   </el-form-item>
                   <div v-else>
                       <el-form-item class="input" label="问卷名称" prop="exampaperName">
                           <el-input v-model="ruleForm.exampaperName"
                                     placeholder="问卷名称" readonly></el-input>
                       </el-form-item>
                   </div>
               </el-col>
			   <el-col :span="12">
			       <el-form-item class="input" v-if="type!='info'"  label="结束语" prop="exampaperJieshuyu">
			           <el-input v-model="ruleForm.exampaperJieshuyu" type="textarea"
                                 @input="onTypoInput('paperEnd')"
			                     placeholder="结束语" clearable  :readonly="ro.exampaperJieshuyu"></el-input>
                       <div v-if="fieldTypo.paperEnd.checking" class="typo-check-bar">
                           <span class="typo-checking">正在智能检测错别字...</span>
                       </div>
                       <div v-if="fieldTypo.paperEnd.issues.length > 0" class="typo-panel">
                           <div class="typo-summary">发现可疑错别字</div>
                           <div v-for="(item,index) in fieldTypo.paperEnd.issues" :key="index" class="typo-item">
                               {{index + 1}}. {{item.position || getIssuePosition(item)}}：{{item.original || '空内容'}}
                               <span v-if="item.suggestion" class="typo-suggestion">建议：{{item.suggestion}}</span>
                           </div>
                       </div>
				   </el-form-item>
			       <div v-else>
			           <el-form-item class="input" label="结束语" prop="exampaperJieshuyu">
			               <el-input v-model="ruleForm.exampaperJieshuyu" type="textarea"
			                         placeholder="结束语" readonly></el-input>
			           </el-form-item>
			       </div>
			   </el-col>
			   
                <el-col :span="12">
                    <el-form-item class="select" v-if="type!='info'"  label="问卷状态" prop="exampaperTypes">
                        <el-select v-model="ruleForm.exampaperTypes" placeholder="请选择问卷状态">
                            <el-option
                                v-for="(item,index) in exampaperTypesOptions"
                                v-bind:key="item.codeIndex"
                                :label="item.indexName"
                                :value="item.codeIndex">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <div v-else>
                        <el-form-item class="input" label="问卷状态" prop="exampaperValue">
                        <el-input v-model="ruleForm.exampaperValue"
                            placeholder="问卷状态" readonly></el-input>
                        </el-form-item>
                    </div>
                </el-col>
            </el-row>
            <div v-if="type!='info' || ruleForm.id" class="question-edit-block">
                <div class="question-edit-title">
                    <span>{{ type=='info' ? '题目浏览' : '题目管理' }}</span>
                    <el-button v-if="type!='info'" size="mini" type="primary" icon="el-icon-plus" @click="resetQuestionForm()">新增题目</el-button>
                </div>
                <el-table size="mini" border :data="questionList" v-loading="questionLoading">
                    <el-table-column prop="examquestionSequence" label="排序" width="80" align="center"></el-table-column>
                    <el-table-column prop="examquestionName" label="题目名称" min-width="220"></el-table-column>
                    <el-table-column prop="examquestionValue" label="题目类型" width="120" align="center"></el-table-column>
                    <el-table-column label="选项" min-width="260">
                        <template slot-scope="scope">
                            <div v-if="formatQuestionOptions(scope.row.examquestionOptions).length" class="question-option-view">
                                <el-tag
                                    v-for="option in formatQuestionOptions(scope.row.examquestionOptions)"
                                    :key="option.code + option.text"
                                    size="mini"
                                    type="info">
                                    {{ option.code }}. {{ option.text }}
                                </el-tag>
                            </div>
                            <span v-else>填空题，无固定选项</span>
                        </template>
                    </el-table-column>
                    <el-table-column v-if="type!='info'" label="操作" width="180" align="center">
                        <template slot-scope="scope">
                            <el-button size="mini" type="primary" @click="editQuestion(scope.row)">修改</el-button>
                            <el-button size="mini" type="danger" @click="deleteQuestion(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>

                <el-form v-if="type!='info'" ref="questionForm" :model="questionForm" :rules="questionRules" label-width="80px" class="question-form">
                    <el-form-item label="题目名称" prop="examquestionName">
                        <el-input type="textarea" :rows="3" v-model="questionForm.examquestionName" @input="onTypoInput('questionName')" placeholder="请输入题目名称"></el-input>
                        <div v-if="questionNameTypo.checking" class="typo-check-bar">
                            <span class="typo-checking">正在智能检测错别字...</span>
                        </div>
                        <div v-if="questionNameTypo.issues.length > 0" class="typo-panel">
                            <div class="typo-summary">发现可疑错别字</div>
                            <div v-for="(item,index) in questionNameTypo.issues" :key="index" class="typo-item">
                                {{index + 1}}. {{item.position || getIssuePosition(item)}}：{{item.original || '空内容'}}
                                <span v-if="item.suggestion" class="typo-suggestion">建议：{{item.suggestion}}</span>
                            </div>
                        </div>
                    </el-form-item>
                    <el-row :gutter="16">
                        <el-col :span="12">
                            <el-form-item label="题目类型" prop="examquestionTypes">
                                <el-select v-model="questionForm.examquestionTypes" placeholder="请选择题目类型" @change="questionTypeChange">
                                    <el-option
                                        v-for="item in examquestionTypesOptions"
                                        :key="item.codeIndex"
                                        :label="item.indexName"
                                        :value="item.codeIndex">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="12">
                            <el-form-item label="排序" prop="examquestionSequence">
                                <el-input v-model="questionForm.examquestionSequence" placeholder="按数字从小到大排序"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-form-item v-if="questionForm.examquestionTypes != 4" label="选项">
                        <div class="question-option-editor" v-for="(option,index) in questionOptions" :key="index">
                            <el-input class="question-option-code" v-model="option.code" placeholder="A"></el-input>
                            <div class="question-option-text">
                                <el-input v-model="option.text" @input="onTypoInput('option' + index, option.text)" placeholder="请输入选项内容"></el-input>
                                <div v-if="getOptionTypo(index).checking" class="typo-check-bar">
                                    <span class="typo-checking">正在智能检测错别字...</span>
                                </div>
                                <div v-if="getOptionTypo(index).issues.length > 0" class="typo-panel">
                                    <div class="typo-summary">发现可疑错别字</div>
                                    <div v-for="(item,issueIndex) in getOptionTypo(index).issues" :key="issueIndex" class="typo-item">
                                        {{issueIndex + 1}}. {{item.position || getIssuePosition(item)}}：{{item.original || '空内容'}}
                                        <span v-if="item.suggestion" class="typo-suggestion">建议：{{item.suggestion}}</span>
                                    </div>
                                </div>
                            </div>
                            <el-button type="danger" icon="el-icon-delete" circle @click="removeQuestionOption(index)"></el-button>
                        </div>
                        <el-button size="small" type="primary" icon="el-icon-plus" @click="addQuestionOption">添加选项</el-button>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="saveQuestion">保存题目</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <el-form-item class="btn">
                <el-button v-if="type!='info'" type="primary" class="btn-success" @click="onSubmit">提交</el-button>
                <el-button v-if="type!='info'" class="btn-close" @click="back()">取消</el-button>
                <el-button v-if="type=='info'" class="btn-close" @click="back()">返回</el-button>
            </el-form-item>
        </el-form>
    </div>
</template>
<script>
    import styleJs from "../../../utils/style.js";
    // 数字，邮件，手机，url，身份证校验
    import { isNumber,isIntNumer,isEmail,isPhone, isMobile,isURL,checkIdCard } from "@/utils/validate";
    export default {
        data() {
            return {
                addEditForm:null,
                id: '',
                type: '',
                sessionTable : "",//登录账户所在表名
                role : "",//权限
                ro:{
                    exampaperName: false,
					exampaperJieshuyu: false,
                    exampaperTypes: false,
                },
                ruleForm: {
                    exampaperName: '',
                    exampaperDate: 0,
					exampaperJieshuyu: '',
                    exampaperTypes: '',
                },
                exampaperTypesOptions : [],
                examquestionTypesOptions: [],
                questionLoading: false,
                questionList: [],
                questionOptions: [],
                questionForm: {
                    id: null,
                    tempId: null,
                    exampaperId: '',
                    examquestionName: '',
                    examquestionOptions: '',
                    examquestionTypes: '',
                    examquestionSequence: 1,
                },
                questionNameTypo: {
                    checking: false,
                    issues: [],
                    checkedText: '',
                    timer: null,
                },
                fieldTypo: {
                    paperName: { checking: false, issues: [], checkedText: '', timer: null },
                    paperEnd: { checking: false, issues: [], checkedText: '', timer: null },
                },
                optionTypos: {},
                questionRules: {
                    examquestionName: [
                        { required: true, message: '题目名称不能为空', trigger: 'blur' },
                    ],
                    examquestionTypes: [
                        { required: true, message: '请选择题目类型', trigger: 'change' },
                    ],
                    examquestionSequence: [
                        { required: true, message: '排序不能为空', trigger: 'blur' },
                    ],
                },
                rules: {
                   exampaperName: [
                              { required: true, message: '问卷名称不能为空', trigger: 'blur' },
                          ],
				   exampaperJieshuyu: [
							  { required: true, message: '结束语不能为空', trigger: 'blur' },
					      ],
                   exampaperTypes: [
                              { required: true, message: '问卷状态不能为空', trigger: 'blur' },
                          ],
                }
            };
        },
        props: ["parent"],
        computed: {
        },
        created() {
            //获取当前登录用户的信息
            this.sessionTable = this.$storage.get("sessionTable");
            this.role = this.$storage.get("role");

            if (this.role != "管理员"){
            }
            this.addEditForm = styleJs.addStyle();
            this.addEditStyleChange()
            this.addEditUploadStyleChange()
            //获取下拉框信息
                this.$http({
                    url:`dictionary/page?page=1&limit=100&sort=&order=&dicCode=exampaper_types`,
                    method: "get"
                }).then(({ data }) => {
                    if (data && data.code === 0) {
                        this.exampaperTypesOptions = data.data.list;
                    }
                });
                this.$http({
                    url:`dictionary/page?page=1&limit=100&sort=&order=&dicCode=examquestion_types`,
                    method: "get"
                }).then(({ data }) => {
                    if (data && data.code === 0) {
                        this.examquestionTypesOptions = data.data.list;
                    }
                });


        },
        mounted() {
        },
        methods: {
            getTypoState(type) {
                if (type === 'paperName' || type === 'paperEnd') {
                    return this.fieldTypo[type];
                }
                if (String(type).indexOf('option') === 0) {
                    if (!this.optionTypos[type]) {
                        this.$set(this.optionTypos, type, { checking: false, issues: [], checkedText: '', timer: null });
                    }
                    return this.optionTypos[type];
                }
                return this.questionNameTypo;
            },
            getTypoText(type) {
                if (type === 'paperName') {
                    return this.ruleForm.exampaperName;
                }
                if (type === 'paperEnd') {
                    return this.ruleForm.exampaperJieshuyu;
                }
                if (String(type).indexOf('option') === 0) {
                    const index = Number(String(type).replace('option', ''));
                    return this.questionOptions[index] ? this.questionOptions[index].text : '';
                }
                return this.questionForm.examquestionName;
            },
            getOptionTypo(index) {
                return this.getTypoState('option' + index);
            },
            resetTypoState(type) {
                const state = this.getTypoState(type);
                if (state.timer) {
                    clearTimeout(state.timer);
                }
                state.checking = false;
                state.issues = [];
                state.checkedText = '';
            },
            onTypoInput(type) {
                const state = this.getTypoState(type);
                state.issues = [];
                state.checkedText = '';
                if (state.timer) {
                    clearTimeout(state.timer);
                }
                state.timer = setTimeout(() => {
                    this.checkTypos(type);
                }, 600);
            },
            checkTypos(type) {
                const state = this.getTypoState(type);
                const text = this.getTypoText(type);
                if (!text) {
                    this.resetTypoState(type);
                    return Promise.resolve(false);
                }
                state.checking = true;
                return this.$http({
                    url: "examquestion/checkTypos",
                    method: "post",
                    data: { text: text }
                }).then(({ data }) => {
                    state.checking = false;
                    if (data && data.code === 0) {
                        state.issues = data.data || [];
                        state.checkedText = text;
                        return !!data.hasIssues;
                    }
                    return false;
                }).catch(() => {
                    state.checking = false;
                    return false;
                });
            },
            buildTypoMessage(type) {
                return this.getTypoState(type).issues.map(item => {
                    return `${item.reason}：${item.original}，建议改为 ${item.suggestion}`;
                }).join("<br>");
            },
            getIssuePosition(item) {
                if (item && typeof item.start === "number" && item.start >= 0) {
                    return `第${item.start + 1}个字符`;
                }
                return "位置未知";
            },
            confirmTyposIfNeeded(type) {
                return this.checkTypos(type).then(hasIssues => {
                    if (!hasIssues) {
                        return true;
                    }
                    return this.$confirm(this.buildTypoMessage(type), "题目名称发现可疑错别字", {
                        confirmButtonText: "继续保存",
                        cancelButtonText: "返回修改",
                        type: "warning",
                        dangerouslyUseHTMLString: true
                    }).then(() => true).catch(() => false);
                });
            },
            loadQuestions() {
                if (!this.ruleForm.id) {
                    return;
                }
                this.questionLoading = true;
                this.$http({
                    url: "examquestion/page",
                    method: "get",
                    params: {
                        page: 1,
                        limit: 999,
                        orderBy: "examquestion_sequence",
                        order: "asc",
                        exampaperId: this.ruleForm.id
                    }
                }).then(({ data }) => {
                    if (data && data.code === 0) {
                        this.questionList = data.data.list || [];
                    } else {
                        this.questionList = [];
                    }
                    this.questionLoading = false;
                });
            },
            parseQuestionOptions(optionsText) {
                try {
                    return JSON.parse(optionsText || "[]");
                } catch (e) {
                    return [];
                }
            },
            formatQuestionOptions(optionsText) {
                const options = this.parseQuestionOptions(optionsText);
                if (!Array.isArray(options)) {
                    return [];
                }
                return options.filter(item => item && (item.code || item.text));
            },
            getNextQuestionSequence() {
                if (!this.questionList.length) {
                    return 1;
                }
                const maxSequence = Math.max.apply(null, this.questionList.map(item => Number(item.examquestionSequence) || 0));
                return maxSequence + 1;
            },
            resetQuestionForm() {
                this.questionForm = {
                    id: null,
                    tempId: null,
                    exampaperId: this.ruleForm.id,
                    examquestionName: '',
                    examquestionOptions: '',
                    examquestionTypes: '',
                    examquestionSequence: this.getNextQuestionSequence(),
                };
                this.resetTypoState('questionName');
                this.questionOptions = [
                    { code: 'A', text: '' },
                    { code: 'B', text: '' },
                ];
                this.$nextTick(() => {
                    if (this.$refs.questionForm) {
                        this.$refs.questionForm.clearValidate();
                    }
                });
            },
            editQuestion(row) {
                this.questionForm = {
                    id: row.id,
                    tempId: row.tempId,
                    exampaperId: this.ruleForm.id,
                    examquestionName: row.examquestionName,
                    examquestionOptions: row.examquestionOptions,
                    examquestionTypes: row.examquestionTypes,
                    examquestionSequence: row.examquestionSequence,
                };
                this.resetTypoState('questionName');
                this.questionOptions = this.parseQuestionOptions(row.examquestionOptions);
            },
            questionTypeChange(type) {
                if (type == 4) {
                    this.questionOptions = [];
                } else if (type == 3) {
                    this.questionOptions = [
                        { code: 'A', text: '对' },
                        { code: 'B', text: '错' },
                    ];
                } else if (this.questionOptions.length === 0) {
                    this.questionOptions = [
                        { code: 'A', text: '' },
                        { code: 'B', text: '' },
                    ];
                }
            },
            addQuestionOption() {
                const code = String.fromCharCode(65 + this.questionOptions.length);
                this.questionOptions.push({ code: code, text: '' });
            },
            removeQuestionOption(index) {
                this.questionOptions.splice(index, 1);
                this.$delete(this.optionTypos, 'option' + index);
            },
            saveQuestion() {
                this.$refs.questionForm.validate(valid => {
                    if (!valid) {
                        return;
                    }
                    if (this.questionForm.examquestionTypes != 4) {
                        const validOptions = this.questionOptions.filter(item => item.code && item.text);
                        if (validOptions.length === 0) {
                            this.$message.error('请至少填写一个选项');
                            return;
                        }
                        this.questionForm.examquestionOptions = JSON.stringify(validOptions);
                    } else {
                        this.questionForm.examquestionOptions = '[]';
                    }
                    this.confirmTyposIfNeeded('questionName').then(canSave => {
                        if (!canSave) {
                            return;
                        }
                        if (!this.ruleForm.id) {
                            const localQuestion = Object.assign({}, this.questionForm, {
                                tempId: this.questionForm.tempId || this.getUUID(),
                                id: null,
                                exampaperId: '',
                                examquestionOptions: this.questionForm.examquestionOptions,
                                examquestionValue: this.getQuestionTypeName(this.questionForm.examquestionTypes)
                            });
                            const index = this.questionList.findIndex(item => item.tempId === localQuestion.tempId);
                            if (index > -1) {
                                this.$set(this.questionList, index, localQuestion);
                            } else {
                                this.questionList.push(localQuestion);
                            }
                            this.questionList.sort((a, b) => (Number(a.examquestionSequence) || 0) - (Number(b.examquestionSequence) || 0));
                            this.$message.success('题目已暂存，提交问卷后自动保存');
                            this.resetQuestionForm();
                            return;
                        }
                        this.questionForm.exampaperId = this.ruleForm.id;
                        this.$http({
                            url: `examquestion/${!this.questionForm.id ? "save" : "update"}`,
                            method: "post",
                            data: this.questionForm
                        }).then(({ data }) => {
                            if (data && data.code === 0) {
                                this.$message.success('题目保存成功');
                                this.loadQuestions();
                                this.resetQuestionForm();
                            } else {
                                this.$message.error(data.msg);
                            }
                        });
                    });
                });
            },
            getQuestionTypeName(type) {
                const item = this.examquestionTypesOptions.find(option => String(option.codeIndex) === String(type));
                return item ? item.indexName : '';
            },
            deleteQuestion(row) {
                if (!this.ruleForm.id) {
                    this.questionList = this.questionList.filter(item => item.tempId !== row.tempId);
                    this.resetQuestionForm();
                    return;
                }
                this.$confirm('确定删除该题目？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.$http({
                        url: "examquestion/delete",
                        method: "post",
                        data: [Number(row.id)]
                    }).then(({ data }) => {
                        if (data && data.code === 0) {
                            this.$message.success('题目删除成功');
                            this.loadQuestions();
                            this.resetQuestionForm();
                        } else {
                            this.$message.error(data.msg);
                        }
                    });
                });
            },
            savePendingQuestions(exampaperId) {
                const pendingQuestions = this.questionList.filter(item => !item.id);
                if (pendingQuestions.length === 0) {
                    return Promise.resolve();
                }
                const saves = pendingQuestions.map(item => {
                    const data = Object.assign({}, item, {
                        id: null,
                        tempId: undefined,
                        exampaperId: exampaperId
                    });
                    return this.$http({
                        url: "examquestion/save",
                        method: "post",
                        data: data
                    });
                });
                return Promise.all(saves);
            },
            // 下载
            download(file){
                window.open(`${file}`)
            },
            // 初始化
            init(id,type) {
                if (id) {
                    this.id = id;
                    this.type = type;
                }
                if(this.type=='info'||this.type=='else'){
                    this.info(id);
                }else if(this.type=='cross'){
                    var obj = this.$storage.getObj('crossObj');
                    for (var o in obj){

                      if(o=='exampaperName'){
                          this.ruleForm.exampaperName = obj[o];
                          this.ro.exampaperName = true;
                          continue;
                      }
                      if(o=='exampaperTypes'){
                          this.ruleForm.exampaperTypes = obj[o];
                          this.ro.exampaperTypes = true;
                          continue;
                      }
                    }
                }
                // 获取用户信息
                this.$http({
                    url:`${this.$storage.get("sessionTable")}/session`,
                    method: "get"
                }).then(({ data }) => {
                    if (data && data.code === 0) {
                        var json = data.data;
                    } else {
                        this.$message.error(data.msg);
                    }
                });
            },
            // 多级联动参数
            info(id) {
                this.$http({
                    url: `exampaper/info/${id}`,
                    method: 'get'
                }).then(({ data }) => {
                    if (data && data.code === 0) {
                        this.ruleForm = data.data;
                        if (this.type == 'info') {
                            this.loadQuestions();
                        }
                        if (this.type != 'info') {
                            this.loadQuestions();
                            this.resetQuestionForm();
                        }
                        //解决前台上传图片后台不显示的问题
                        let reg=new RegExp('../../../upload','g')//g代表全部
                    } else {
                        this.$message.error(data.msg);
                    }
                });
            },
            // 提交
            onSubmit() {
                this.$refs["ruleForm"].validate(valid => {
                    if (valid) {
                            this.ruleForm.exampaperDate = this.ruleForm.exampaperDate || 0;
                            this.$http({
                                url:`exampaper/${!this.ruleForm.id ? "save" : "update"}`,
                                method: "post",
                                data: this.ruleForm
                            }).then(({ data }) => {
                                if (data && data.code === 0) {
                                    const exampaperId = this.ruleForm.id || (data.data && data.data.id) || data.id;
                                    this.savePendingQuestions(exampaperId).then(() => {
                                        this.$message({
                                            message: "操作成功",
                                            type: "success",
                                            duration: 1500,
                                            onClose: () => {
                                                this.parent.showFlag = true;
                                                this.parent.addOrUpdateFlag = false;
                                                this.parent.exampaperCrossAddOrUpdateFlag = false;
                                                this.parent.search();
                                                this.parent.contentStyleChange();
                                            }
                                        });
                                    });
                                } else {
                                    this.$message.error(data.msg);
                                }
                            });
                    }
                });
            },
            // 获取uuid
            getUUID () {
                return new Date().getTime();
            },
            // 返回
            back() {
                this.parent.showFlag = true;
                this.parent.addOrUpdateFlag = false;
                this.parent.exampaperCrossAddOrUpdateFlag = false;
                this.parent.contentStyleChange();
            },
            //图片

            addEditStyleChange() {
                this.$nextTick(()=>{
                    // input
                    document.querySelectorAll('.addEdit-block .input .el-input__inner').forEach(el=>{
                        el.style.height = this.addEditForm.inputHeight
                        el.style.color = this.addEditForm.inputFontColor
                        el.style.fontSize = this.addEditForm.inputFontSize
                        el.style.borderWidth = this.addEditForm.inputBorderWidth
                        el.style.borderStyle = this.addEditForm.inputBorderStyle
                        el.style.borderColor = this.addEditForm.inputBorderColor
                        el.style.borderRadius = this.addEditForm.inputBorderRadius
                        el.style.backgroundColor = this.addEditForm.inputBgColor
                    })
                    document.querySelectorAll('.addEdit-block .input .el-form-item__label').forEach(el=>{
                        el.style.lineHeight = this.addEditForm.inputHeight
                        el.style.color = this.addEditForm.inputLableColor
                        el.style.fontSize = this.addEditForm.inputLableFontSize
                    })
                    // select
                    document.querySelectorAll('.addEdit-block .select .el-input__inner').forEach(el=>{
                        el.style.height = this.addEditForm.selectHeight
                        el.style.color = this.addEditForm.selectFontColor
                        el.style.fontSize = this.addEditForm.selectFontSize
                        el.style.borderWidth = this.addEditForm.selectBorderWidth
                        el.style.borderStyle = this.addEditForm.selectBorderStyle
                        el.style.borderColor = this.addEditForm.selectBorderColor
                        el.style.borderRadius = this.addEditForm.selectBorderRadius
                        el.style.backgroundColor = this.addEditForm.selectBgColor
                    })
                    document.querySelectorAll('.addEdit-block .select .el-form-item__label').forEach(el=>{
                        el.style.lineHeight = this.addEditForm.selectHeight
                        el.style.color = this.addEditForm.selectLableColor
                        el.style.fontSize = this.addEditForm.selectLableFontSize
                    })
                    document.querySelectorAll('.addEdit-block .select .el-select__caret').forEach(el=>{
                        el.style.color = this.addEditForm.selectIconFontColor
                        el.style.fontSize = this.addEditForm.selectIconFontSize
                    })
                    // date
                    document.querySelectorAll('.addEdit-block .date .el-input__inner').forEach(el=>{
                        el.style.height = this.addEditForm.dateHeight
                        el.style.color = this.addEditForm.dateFontColor
                        el.style.fontSize = this.addEditForm.dateFontSize
                        el.style.borderWidth = this.addEditForm.dateBorderWidth
                        el.style.borderStyle = this.addEditForm.dateBorderStyle
                        el.style.borderColor = this.addEditForm.dateBorderColor
                        el.style.borderRadius = this.addEditForm.dateBorderRadius
                        el.style.backgroundColor = this.addEditForm.dateBgColor
                    })
                    document.querySelectorAll('.addEdit-block .date .el-form-item__label').forEach(el=>{
                        el.style.lineHeight = this.addEditForm.dateHeight
                        el.style.color = this.addEditForm.dateLableColor
                        el.style.fontSize = this.addEditForm.dateLableFontSize
                    })
                    document.querySelectorAll('.addEdit-block .date .el-input__icon').forEach(el=>{
                        el.style.color = this.addEditForm.dateIconFontColor
                        el.style.fontSize = this.addEditForm.dateIconFontSize
                        el.style.lineHeight = this.addEditForm.dateHeight
                    })
                    // upload
                    let iconLineHeight = parseInt(this.addEditForm.uploadHeight) - parseInt(this.addEditForm.uploadBorderWidth) * 2 + 'px'
                    document.querySelectorAll('.addEdit-block .upload .el-upload--picture-card').forEach(el=>{
                        el.style.width = this.addEditForm.uploadHeight
                        el.style.height = this.addEditForm.uploadHeight
                        el.style.borderWidth = this.addEditForm.uploadBorderWidth
                        el.style.borderStyle = this.addEditForm.uploadBorderStyle
                        el.style.borderColor = this.addEditForm.uploadBorderColor
                        el.style.borderRadius = this.addEditForm.uploadBorderRadius
                        el.style.backgroundColor = this.addEditForm.uploadBgColor
                    })
                    document.querySelectorAll('.addEdit-block .upload .el-form-item__label').forEach(el=>{
                        el.style.lineHeight = this.addEditForm.uploadHeight
                        el.style.color = this.addEditForm.uploadLableColor
                        el.style.fontSize = this.addEditForm.uploadLableFontSize
                    })
                    document.querySelectorAll('.addEdit-block .upload .el-icon-plus').forEach(el=>{
                        el.style.color = this.addEditForm.uploadIconFontColor
                        el.style.fontSize = this.addEditForm.uploadIconFontSize
                        el.style.lineHeight = iconLineHeight
                        el.style.display = 'block'
                    })
                    // 多文本输入框
                    document.querySelectorAll('.addEdit-block .textarea .el-textarea__inner').forEach(el=>{
                        el.style.height = this.addEditForm.textareaHeight
                        el.style.color = this.addEditForm.textareaFontColor
                        el.style.fontSize = this.addEditForm.textareaFontSize
                        el.style.borderWidth = this.addEditForm.textareaBorderWidth
                        el.style.borderStyle = this.addEditForm.textareaBorderStyle
                        el.style.borderColor = this.addEditForm.textareaBorderColor
                        el.style.borderRadius = this.addEditForm.textareaBorderRadius
                        el.style.backgroundColor = this.addEditForm.textareaBgColor
                    })
                    document.querySelectorAll('.addEdit-block .textarea .el-form-item__label').forEach(el=>{
                        // el.style.lineHeight = this.addEditForm.textareaHeight
                        el.style.color = this.addEditForm.textareaLableColor
                        el.style.fontSize = this.addEditForm.textareaLableFontSize
                    })
                    // 保存
                    document.querySelectorAll('.addEdit-block .btn .btn-success').forEach(el=>{
                        el.style.width = this.addEditForm.btnSaveWidth
                        el.style.height = this.addEditForm.btnSaveHeight
                        el.style.color = this.addEditForm.btnSaveFontColor
                        el.style.fontSize = this.addEditForm.btnSaveFontSize
                        el.style.borderWidth = this.addEditForm.btnSaveBorderWidth
                        el.style.borderStyle = this.addEditForm.btnSaveBorderStyle
                        el.style.borderColor = this.addEditForm.btnSaveBorderColor
                        el.style.borderRadius = this.addEditForm.btnSaveBorderRadius
                        el.style.backgroundColor = this.addEditForm.btnSaveBgColor
                    })
                    // 返回
                    document.querySelectorAll('.addEdit-block .btn .btn-close').forEach(el=>{
                        el.style.width = this.addEditForm.btnCancelWidth
                        el.style.height = this.addEditForm.btnCancelHeight
                        el.style.color = this.addEditForm.btnCancelFontColor
                        el.style.fontSize = this.addEditForm.btnCancelFontSize
                        el.style.borderWidth = this.addEditForm.btnCancelBorderWidth
                        el.style.borderStyle = this.addEditForm.btnCancelBorderStyle
                        el.style.borderColor = this.addEditForm.btnCancelBorderColor
                        el.style.borderRadius = this.addEditForm.btnCancelBorderRadius
                        el.style.backgroundColor = this.addEditForm.btnCancelBgColor
                    })
                })
            },
            addEditUploadStyleChange() {
                this.$nextTick(()=>{
                    document.querySelectorAll('.addEdit-block .upload .el-upload-list--picture-card .el-upload-list__item').forEach(el=>{
                        el.style.width = this.addEditForm.uploadHeight
                        el.style.height = this.addEditForm.uploadHeight
                        el.style.borderWidth = this.addEditForm.uploadBorderWidth
                        el.style.borderStyle = this.addEditForm.uploadBorderStyle
                        el.style.borderColor = this.addEditForm.uploadBorderColor
                        el.style.borderRadius = this.addEditForm.uploadBorderRadius
                        el.style.backgroundColor = this.addEditForm.uploadBgColor
                    })
                })
            },
        }
    };
</script>
<style lang="scss">
.editor{
  height: 500px;

  & /deep/ .ql-container {
	  height: 310px;
  }
}
.amap-wrapper {
  width: 100%;
  height: 500px;
}
.search-box {
  position: absolute;
}
.addEdit-block {
	margin: -10px;
}
.detail-form-content {
	padding: 12px;
}
.btn .el-button {
  padding: 0;
}
.question-edit-block {
  margin: 16px 12px;
  padding: 14px;
  border: 1px solid #ebeef5;
  background: #fafbff;
}
.question-edit-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  font-weight: 600;
}
.question-form {
  margin-top: 16px;
}
.question-option-editor {
  display: flex;
  gap: 8px;
  margin-bottom: 8px;
  align-items: flex-start;
}
.question-option-view {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.question-option-code {
  width: 76px;
  flex: 0 0 76px;
}
.question-option-text {
  flex: 1;
}
.typo-check-bar {
  margin-top: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.typo-checking {
  color: #909399;
  font-size: 13px;
}
.typo-ok {
  color: #67c23a;
  font-size: 13px;
}
.typo-panel {
  margin-top: 8px;
  width: 100%;
  box-sizing: border-box;
  padding: 8px 10px;
  border: 1px solid #f5c58c;
  border-radius: 4px;
  background: #fff8ee;
  color: #9a5b10;
  font-size: 13px;
  line-height: 1.6;
}
.typo-summary {
  font-weight: 600;
  margin-bottom: 4px;
}
.typo-item {
  word-break: break-word;
}
.typo-suggestion {
  margin-left: 8px;
  color: #8a4b00;
  font-weight: 600;
}
</style>
