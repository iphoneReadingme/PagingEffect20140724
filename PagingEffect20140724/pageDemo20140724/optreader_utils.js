/**
 * 本JS分为客户端执行和服务器端执行两种情况。
 * 客户端执行：页面可定制，但没有进入阅读器时，JS以外链形式被中间件注入到原页面。
 * 服务器端执行：此时一定为预计时，无论页面是否可定制，本JS均执行。根据页面特征判断页面是否定制成功，并进行后续操作。
 *
 *
 * 新小说模式定制失败类型判断
 * 	下一章无法定制的类型进行区分，分为两种：
 *   付费或其他
 *
 * 付费的话通过3个条件可以判断：
 * 1.下一章url里包含vip或者VIP字样
 * 2.下一章有登陆注册弹窗
 * 3.下一章包含VIP或者vip关键字
 *
 * author: LinWenLong
 * time: 20140807
 */
(function(){
    var DEBUG = false;           //用于控制是否打印日志。开发时，设置true；生产部署时，设置为false
    var UC_MODE = false;        //为true时表示定制成功，false表示定制失败

    //公共函数
    var $id = function(id){
        return document.getElementById(id);
    }
    var $qs = function(str){
        return document.querySelector(str);
    }
    var $qa = function(str){
        return document.querySelectorAll(str);
    }
    //END

    var PLATFORM = $qs('meta[name="customizetype"]') && $qs('meta[name="customizetype"]').getAttribute('platform') ? $qs('meta[name="customizetype"]').getAttribute('platform') : 'android';
    var URL = location.href.replace('http://','');



    //工具类
    var utils = {
        chkDomain : function(arr){
            var i;
            for(i in arr){
                if(URL.indexOf(arr[i]) == 0){
                    return true;
                }
            }
            return false;
        }
        ,
        chkUrl : function(arr){
            var i;
            for(i in arr){
                if(URL.indexOf(arr[i]) != -1){
                    return true;
                }
            }
            return false;
        },
        chkTxt:function(keys,boxs){
            var i, j, k;

            for(j=0;j<boxs.length;j++) {
                for(i=0;i<keys.length;i++) {
                    var $obj = document.querySelectorAll(boxs[j]);
                    if($obj.length){
                        for(k=0;k<$obj.length;k++){
                            if( $obj[k] && $obj[k].textContent && $obj[k].textContent.indexOf(keys[i])!=-1 ) {
                                return true;
                            }
                        }
                    }
                }
            }

            return false;
        }
    }

    //检查页面特征
    var chkPage = function(){

        //跳转到URL的VIP URL二级域名前缀检查
        var result = utils.chkDomain(['vip.','vipreader.','vipread.']);
        if(result){
            return 'VIP';
        }

        //跳转到URL的登录页 URL二级域名前缀检查
        result = utils.chkDomain(['login.','reg.']);
        if(result){
            return 'LOGIN';
        }

        //跳转到URL的VIP URL文件名关键字检查
        result = utils.chkUrl(['vip/','noLoginVipChapter.','v_read.'
            ,'VIPContent','SubscribeVIP'
            ,'buyvip'               //http://vip.hongshu.com/buyviplist.php?bid=42148&chpid=1353070, http://www.xdyqw.com/buyviplist.php?bid=37821&chpid=984266
            ,'new-pay.'             //http://book.qq.com/new-pay.html?bid=338408&cid=14&af=3&v=2&c_f=cm467&g_f=
            ,'buynovel.'            //http://my.jjwxc.net/backend/buynovel.php?novelid=1977455&chapterid=27
            ,'/order/'              //http://3gsc.com.cn/order/singleOrder/rid/315608/mid/89
        ]);
        if(result){
            return 'VIP';
        }

        //跳转到URL的登录页的，URL文件名关键字检查
        result = utils.chkUrl(['login.','Login.','reg.'
            ,'/user'               //http://3gsc.com.cn/order/singleOrder/rid/315608/mid/89，http://www.cwzww.com/userSignin.php?destUrl=http%3A%2F%2Fwww.cwzww.com%2Fvip%2Fread%2F42174%2F1089986
        ]);
        if(result){
            return 'LOGIN';
        }

        //内容关键字检查
        result = utils.chkTxt(['当前章节需要付费阅读','VIP章节订阅列表',           //http://book.zongheng.com/chapter/notorder/305236/5587485.html
            'VIP章节','单章订阅',                          //,'更多精彩内容请充值','阅读本章需要支付'  http://www.kanshu.com/new/ks_user/subscription?book_id=73545&chapter_id=2884960
            'VIP订阅',                                   //http://www.fbook.net/vip/buyVIPNode.asp?bookid=23034
            'VIP章节订阅提示'                             //http://vip.xxsy.net/vipbook.aspx?zhangjieid=6005744&juanid=2&bookid=545419
        ],[
            'h2','title','.title'
        ]);
        if(result){
            return 'VIP';
        }
        //在body里找关键字
        result = utils.chkTxt([
            '给帐户充值'                                //http://www6.2200book.com/modules/obook/reader.php?aid=226666&cid=130325
            ,'本章节是VIP章节'                            //http://vip.fmx.cn/modules/obook/reader.php?aid=103932&cid=404975
        ],[
            'body'
        ]);
        if(result){
            return 'VIP';
        }

        //在body里找内容关键字检查
        result = utils.chkTxt([
            ,'此章节必须登录才能阅读'                      //http://www.qifeng.com/Book/read/id/298636/bid/3309
            ,'下次自动登录'                               //http://www6.2200book.com/modules/obook/reader.php?aid=112354&cid=87623
            ,'您还不是本站会员'                             //http://vip.fmx.cn/modules/obook/reader.php?oid=3793&cid=405175
            ,'忘记密码了'                                //http://www.motie.com/book/14982_309027
        ],[
            'body'
        ]);
        if(result){
            return 'LOGIN';
        }
    }

    //封装DOM标注，输出为JSON数据
    var getData = function(){
        var novel_type; //3:目录页; 2:图片小说正文; 1:文字小说正文
        var json;

        var getDirData = function(_novel_type){
            var resultJSON = {
                status:'0',             //为了保持与正文页数据一致性。因目录页本质上没有成功或失败状态
                info:{
                    uc_novel_type:'3',
                    uc_novel_dir:'',
                    uc_novel_next:'',
                    uc_novel_prev:'',
                    uc_novel_bookname:''
                },
                data:[]
            };
            resultJSON.info.uc_novel_dir = location.href;
            resultJSON.info.uc_novel_next = $id("ucweb_readmode_next") ? $id("ucweb_readmode_next").href : "";
            resultJSON.info.uc_novel_prev = $id("ucweb_readmode_prev") ? $id("ucweb_readmode_prev").href : "";
            resultJSON.info.uc_novel_bookname = $qs('h1') ? $qs('h1').textContent
                                                     : ($id('ucweb_readmode_bookname') ? $id('ucweb_readmode_bookname').textContent : "");
            var urls = Array.prototype.slice.call($qa("a[ucmode='readmode']"));
            var i;
            var count_arr_ = [];

            //android平台下，目录数据需要分段
            if(PLATFORM=='android'){
                var skipNum = 0;
                urls.forEach(function(urlObj,index){
                    if(urlObj.text){
                        var _url_arr = {};
                        _url_arr.title = urlObj.text.replace(/(^\s*)|(\s*$)/g, "");
                        _url_arr.url = urlObj.href ? urlObj.href.replace(/%20/g,'') : urlObj.rel.replace(/%20/g,'');       //rel属性兼容jjwxc.net网站的VIP章节
                        count_arr_.push(_url_arr);
                    }else{
                        skipNum++;      //跳过不正常的链接
                    }

                    //TODO:测试是2为整除数，生产环境是100
                    if(count_arr_.length % 100 == 0 || index == urls.length-skipNum-1){             //这里需要再减去skipNum，用于处理最后一段数据
//                        if(count_arr_.length % 2 == 0 || index == urls.length-skipNum-1){
                        resultJSON.data.push(count_arr_);
                        count_arr_ = [];
                    }
                });
            }else{      //iOS平台下不分段，直接添加data数组中
                urls.forEach(function(urlObj){
                    if(urlObj.text){
                        var _url_arr = {};
                        _url_arr.title = urlObj.text.replace(/(^\s*)|(\s*$)/g, "");
                        _url_arr.url = urlObj.href ? urlObj.href.replace(/%20/g,'') : urlObj.rel.replace(/%20/g,'');       //rel属性兼容jjwxc.net网站的VIP章节
                        resultJSON.data.push(_url_arr);
                    }
                });
            }
            return resultJSON;
        }
        var getDetailData = function(_novel_type){
            var resultJSON = {
                status:'0',
                info:{
                    uc_novel_type:_novel_type.toString(),
                    uc_novel_title:'',
                    uc_novel_cont:'',
                    uc_novel_url:'',
                    uc_novel_dir:'',
                    uc_novel_next:'',
                    uc_novel_prev:''
                }
            };
            //清理正文
            var uc_novel_cont="";
            var $uc_novel_cont = $qs("[ucmode='readmode']");

            if($qa('img[id^=ucreader_content_image_]').length){     //适屏下（图片是多张）的图片小说
                var atts = Array.prototype.slice.call($qa('img[id^=ucreader_content_image_]'));
                atts.forEach(function(ele){
//                    uc_novel_cont += ele.outerHTML;       //中间件不支持outerHTML
                    uc_novel_cont += '<img src="{0}" id="{1}">'.replace('{0}',ele.src).replace('{1}',ele.id);
                });
            }else if($uc_novel_cont && $uc_novel_cont.nodeName=='IMG'){       //绽放下（图片是一张）的图片小说的正文处理。
                var atts = Array.prototype.slice.call($qa("[ucmode='readmode']"));
                atts.forEach(function(ele){
//                    uc_novel_cont += ele.outerHTML;       //中间件不支持outerHTML
                    uc_novel_cont += '<img src="{0}" ucmode="readmode">'.replace('{0}',ele.src);
                });
            }else{                                      //文字小说时
                var $removes = $uc_novel_cont.querySelectorAll('style,script');
                for(var i=0; i<$removes.length; i++){
                    try{
                        $uc_novel_cont.removeChild($removes[i]);
                    }catch(e){}
                }
                uc_novel_cont = $uc_novel_cont.innerHTML;     //正文内容


                //使用特有符号替换掉所有换行字符。注意：文字小说时，才需要做过滤。
                uc_novel_cont = uc_novel_cont.replace(/<script.*?>.*?<\/script>/ig, '');
                uc_novel_cont = uc_novel_cont.replace(/<style.*?>.*?<\/style>/ig, '');
                uc_novel_cont = uc_novel_cont.replace(/<[/^>]p>/g, "UCbreakLine");
                uc_novel_cont = uc_novel_cont.replace(/<[/^>]div>/g, "UCbreakLine");
                uc_novel_cont = uc_novel_cont.replace(/<br>/g, "UCbreakLine");
                //替换掉所有的HTML标签
                uc_novel_cont = uc_novel_cont.replace(/(<\/?[^>]*>)|([\n])/g, "");      //改为这里是对非汉字的空格分隔的支持
                //重新转换回换行字符
                uc_novel_cont = uc_novel_cont.replace(/UCbreakLine[\s\n]*/g, "<br>");
                uc_novel_cont = uc_novel_cont.replace(/(<br>)+/g, "<br>"); //将多行换行，替换为一个换行
                uc_novel_cont = uc_novel_cont.replace(/&nbsp;/g, " "); //将多行换行，替换为一个换行
            }
            //END

            resultJSON.info.uc_novel_title = $qs("h1")
                ? $qs("h1").textContent
                : ( $id('ucweb_readmode_chaptername') ? $id('ucweb_readmode_chaptername').textContent : '');
            resultJSON.info.uc_novel_title = resultJSON.info.uc_novel_title.replace(/(^\s*)|(\s*$)/g, "");
            resultJSON.info.uc_novel_cont = uc_novel_cont;
            resultJSON.info.uc_novel_url = location.href;
            resultJSON.info.uc_novel_dir = $id("ucweb_readmode_contents").href;
            resultJSON.info.uc_novel_next = $id("ucweb_readmode_next") ? $id("ucweb_readmode_next").href : "";
            resultJSON.info.uc_novel_prev = $id("ucweb_readmode_prev") ? $id("ucweb_readmode_prev").href : "";
            resultJSON.status = '0';

            return resultJSON;
        }

        //判断页面类型
        if($qs('meta[name="customizetype"]') && $qs('meta[name="customizetype"]').getAttribute('noveltype') ) {
            novel_type = $qs('meta[name="customizetype"]').getAttribute('noveltype');
        }else{
            novel_type = '-1';        //定制失败，无法判定是哪种类型页面时，返回-1
        }

        if(novel_type == '3' && UC_MODE){
            json = getDirData(novel_type);
        }else if(parseInt(novel_type)>0 && UC_MODE){
            json = getDetailData(novel_type);
        }else{                               //定制失败
            json = {};
            var pagetype = chkPage();
            switch (pagetype)
            {
                case 'VIP':
                    json.status = '2';        //VIP页或需付费
                    break;
                case "LOGIN":
                    json.status = '3';        //需要登录
                    break;
                default:
                    json.status = '1';        //其他
                    break;
            }
        }

        return json;
    }
    var processAndroidResult = function(json){
        if(!json.info || json.info.uc_novel_type != '3') {       //非目录页直接返回数据
            return '[\''+ JSON.stringify(json) +'\']';
        }

        var datas = json.data;
        delete json['data'];
        var result_str = [];
        result_str.push( "'"+ JSON.stringify(json) +"'" );
        datas.forEach(function(ele){
            result_str.push( '\'{"data":'+ JSON.stringify(ele) +'}\'' );
        });
        return '['+ result_str.join(',') +']';
    }
    var main = function(){
        if($qs('meta[name="customizetype"][content="reader"]')){        //表示定制成功
            UC_MODE = true;
        }else{
            UC_MODE = false;
        }

        var result = getData();
        var result_json_txt = '';
        if(PLATFORM=='android'){
            result_json_txt = processAndroidResult(result);
        }else{
            result_json_txt = JSON.stringify(result);
        }

        //转义处理
        result_json_txt = result_json_txt.replace(/\\/g,'\\\\');
        result_json_txt = result_json_txt.replace(/\\"/g,'\\\\"');
        //END

        var script_txt="";
        var script= document.createElement("script");
        if(PLATFORM=='android') {
            script_txt = 'UCShellJava.invoke("", "novel", "extracted_novel", ' + result_json_txt + ', ext);';
        }else{ //iOS接口
            script_txt = 'ucbrowser.novelGetReaderData(\''+ result_json_txt +'\');';
        }
        script_txt = 'function getExtractedNovelData(ext){' + script_txt +'}';
        script_txt += 'getExtractedNovelData("");';

        var tn = document.createTextNode(script_txt);
        script.setAttribute('name','uc_script');        //必须name=uc_script，JS才能在中间件被保留下来
        script.appendChild(tn);
//        script.textContent = 'var uc_novel_data='+ result_json_txt;      //注意：这个语法不兼容中间件，不能使用。留在这里是保留一个警示。

        //在服务器端运行时，清空原DOM的操作
        if($qs('script[name="uc_script"]')
            && /\?__onserver$/g.test($qs('script[name="uc_script"]').getAttribute('src')) )
        {
            var _html = '<head>';
            if(UC_MODE){
                _html += '<meta name="customizetype" content="reader" platform="'+ PLATFORM +'" noveltype="'+ $qs('meta[name="customizetype"]').getAttribute('noveltype') +'">';
            }
            _html += '</head><body></body>';
            document.querySelector('html').innerHTML = _html;
        }
        document.head.appendChild(script);

        if( DEBUG ){
//            console.info(result,script);
//            console.log(result_json_txt);
//            console.info(script_txt);

            if(typeof exports === 'object') {
                exports.novelData =  result;
            }
            if(typeof IS_SLIMER === 'boolean' && IS_SLIMER){
                window.novelData = result;
            }
        }
    }

    if(typeof exports === 'object'){
        exports.novelPage = main;           //用于在NodeJS环境下的测试程序运行
    }else{
        //在服务器端运行时，清空原DOM的操作
        if($qs('script[name="uc_script"]')
            && /\?__onserver$/g.test($qs('script[name="uc_script"]').getAttribute('src')) ) {
            main();
        }else{
            if(DEBUG){
                main();     //为了便于本地注入浏览器调试
            }else{
                if(PLATFORM=='android') {
                    //这是Android版的代码
                    document.addEventListener('DOMContentLoaded', main, false);
                }else{
                    if(navigator.userAgent.indexOf("Chrome")>0){
                        console.log('iOS-DOMContentLoaded');

                        //本地在chrome下调试iOS平台下的逻辑，为了方便开发调试
                        document.addEventListener('DOMContentLoaded', main, false);
                    }else{
                        //这里针对iOS平台的代码
                        document.addEventListener('UCBrowserReady', main, false);
                    }
                }
            }

        }
    }
})();