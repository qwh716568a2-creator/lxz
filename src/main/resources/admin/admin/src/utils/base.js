const base = {
    get() {
        return {
            url : "http://localhost:8080/tongyongwenjuandiaocha/",
            name: "tongyongwenjuandiaocha",
            // 閫€鍑哄埌棣栭〉閾炬帴
            indexUrl: 'http://localhost:8080/tongyongwenjuandiaocha/front/index.html'
        };
    },
    getProjectName(){
        return {
            projectName: "通用问卷调查系统"
        } 
    }
}
export default base
