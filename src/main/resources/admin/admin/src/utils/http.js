import axios from 'axios'
import router from '@/router/router-static'
import storage from '@/utils/storage'

const http = axios.create({
    timeout: 1000 * 86400,
    withCredentials: true,
    baseURL: '/tongyongwenjuandiaocha',
    headers: {
        'Content-Type': 'application/json; charset=utf-8'
    }
})
// 璇锋眰鎷︽埅
http.interceptors.request.use(config => {
    config.headers['Token'] = storage.get('Token') // 璇锋眰澶村甫涓妕oken
    return config
}, error => {
    return Promise.reject(error)
})
// 鍝嶅簲鎷︽埅
http.interceptors.response.use(response => {
    if (response.data && response.data.code === 401) { // 401, token澶辨晥
        router.push({ name: 'login' })
    }
    return response
}, error => {
    return Promise.reject(error)
})
export default http