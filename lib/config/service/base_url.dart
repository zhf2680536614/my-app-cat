//前端BaseUrl
// 生成环境的BaseUrl
const String apiProdBaseUrl = 'https://api.example.com';
// 开发环境的BaseUrl
// 开发环境API基础URL
// 注意事项：
// 1. 真机调试时：确保手机和电脑在同一WiFi网络，使用电脑的实际局域网IP
//    - Windows: 在命令提示符输入 ipconfig 查找IPv4地址
//    - Mac/Linux: 在终端输入 ifconfig 查找inet地址
// 2. 模拟器调试时：使用10.0.2.2（安卓模拟器访问电脑localhost）
// 3. 确保防火墙没有阻止8000端口
const String apiDevBaseUrl = 'http://192.168.108.119:8000'; // 替换为你电脑的实际IP地址
// 测试环境的BaseUrl
const String apiTestBaseUrl = 'https://test-api.example.com';

//后台BaseUrl
// 生成环境的BaseUrl
const String adminProdBaseUrl = 'https://server-api.example.com';
// 开发环境的BaseUrl
const String adminDevBaseUrl = 'https://dev-server-api.example.com';
// 测试环境的BaseUrl
const String adminTestBaseUrl = 'https://test-server-api.example.com';
