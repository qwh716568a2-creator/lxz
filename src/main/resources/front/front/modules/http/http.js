
layui.define(['jquery', 'layer'], function(exports) { //鎻愮ず锛氭ā鍧椾篃鍙互渚濊禆鍏跺畠妯″潡锛屽锛歭ayui.define('layer', callback);
	"use strict";
	var jquery = layui.jquery,
		layer = layui.layer,
		        baseurl = "http://localhost:8080/tongyongwenjuandiaocha/";
        	var http = {
		        domain : "http://8.129.11.174:8080/tongyongwenjuandiaocha/",
        		baseurl: baseurl,
		/**
		 * 鑾峰彇浼犻€掑弬鏁板€?淇敼鏀寔涓枃)
		 */
		getParam: function(name) {
			var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
			var r = window.location.search.substr(1).match(reg);
			if (r != null)
				return decodeURI(r[2]); //瀵瑰弬鏁拌繘琛宒ecodeURI瑙ｇ爜
			return null;
		},
		request: function(url, type, data, callback) {
			//loading灞?
			var index = layer.load(1, {
				shade: [0.1, '#fff'] //0.1閫忔槑搴︾殑鐧借壊鑳屾櫙
			});
			url = baseurl + url;
			data['t'] = jquery.now();
			jquery.ajax({
				url: url,
				beforeSend: function(request) {
					request.setRequestHeader("Token", localStorage.getItem("Token"));
				},
				contentType: 'application/x-www-form-urlencoded',
				data: data,
				dataType: 'json',
				type: type,
				success: function(result, status, xhr) {
					if (result.code == 0) {
						callback(result);
					} else if (result.code == 401) {
						window.parent.location.href = '../login/login.html';
					} else {
						layer.msg(result.msg, {
							time: 2000,
							icon: 5
						})
					}
					layer.close(index);
				},
				error: function(xhr, status, error) {
					console.log(xhr, status, error)
					layer.msg("璇锋眰鎺ュ彛澶辫触", {
						time: 2000,
						icon: 5
					})
					layer.close(index);
				}
			});
		},
		requestJson: function(url, type, data, callback) {
			//loading灞?
			var index = layer.load(1, {
				shade: [0.1, '#fff'] //0.1閫忔槑搴︾殑鐧借壊鑳屾櫙
			});
			url = baseurl + url;
			var params = null;
			data['t'] = jquery.now();
			if (data) {
				params = JSON.stringify(data);
			}
			jquery.ajax({
				url: url,
				beforeSend: function(request) {
					request.setRequestHeader("Token", localStorage.getItem("Token"));
				},
				contentType: 'application/json',
				data: params,
				dataType: 'json',
				type: type,
				success: function(result, status, xhr) {
					if (result.code == 0) {
						callback(result);
					} else if (result.code == 401) {
						window.parent.location.href = '../login/login.html';
					} else {
						layer.msg(result.msg, {
							time: 2000,
							icon: 5
						})
					}
					layer.close(index);
				},
				error: function(xhr, status, error) {
					console.log(xhr, status, error)
					layer.msg("璇锋眰鎺ュ彛澶辫触", {
						time: 2000,
						icon: 5
					})
					layer.close(index);
				},
			});
		},
		upload: function(file, fileName, callback) {
			var url = baseurl + "file/upload";
			var formData = new FormData();
			formData.append('file', file);
			formData.append('fileName', fileName);
			jquery.ajax({
				url: url,
				/*鎺ュ彛鍩熷悕鍦板潃*/
				type: 'post',
				data: formData,
				headers: {
					"Token": localStorage.getItem("Token")
				}, //娣诲姞璇锋眰澶撮儴
				contentType: false,
				processData: false,
				success: function(res) {
					if (res.code == 0) {
						callback(res);
					} else if (res.code == 401) {
						window.parent.location.href = '../login/login.html';
					} else {
						layer.msg(res.msg, {
							time: 2000,
							icon: 5
						})
					}
				}
			})
		}
	}
	//杈撳嚭鎺ュ彛
	exports('http', http);
});
