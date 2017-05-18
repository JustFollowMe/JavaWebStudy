<%@ page language="java" contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>指令查询</title>
<style type="text/css">

#myDiv{
	position:absolute;
	left:50%;
	top:40%;
	margin-left:-200px;
	margin-top:-50px;
}

#command_text{
	width:320px;
	height:22px;
}

#mybutton{
	width:100px;
	height:30px;
}

#content_table{
	font-size:12px;
}

.mouseOver{
	background:#708090;
	color:#FFFAFA;
}

.mouseOut{
	background:#FFFAFA;
	color:#000000;
}

</style>
<script type="text/javascript">

//获取相关词条
function showMoreContent(){

	//首先获得用户输入的内容	
	var content = document.getElementById("command_text");
	if(content.value==""){
		//如果输入框为空时，先清空输入框下面的 数据
		clearContent();
		return;
	}
	//给服务器发送对象的内容
	//由于我们使用的是ajax异步发送数据，所以我们需要创建一个xmlHttp对象
	xmlHttp = createXMLHttpRequest();
	//给服务器发送数据
	//var url = "search.action?keyword="+escape(content.value);
	var url = "search.action?keyword="+encodeURI(encodeURI(content.value));//此种方法可以解决当传中文参数时，后台获取到的值为null的情况
	//true表示JavaScript脚本会在send()方法之后继续执行，而不会等待来自服务器的响应
	//xmlHttp.open("GET",url,true);
	xmlHttp.open("POST",url,true);
	//xmlHttp绑定一个回调方法,这个回调方法会在xmlHttp的状态改变的时候被调用
	//xmlHttp的状态0-4，我们只关心4这个状态，4表示完成（complete），当数据传输过程完成之后，再调用回调方法才有意义
	 xmlHttp.onreadystatechange=callback;
	 xmlHttp.send(null);
	
}

//回调函数
function callback(){
	
	//4代表完成
	if(xmlHttp.readyState==4){
		//200代表服务器响应成功，404代表资源未找到，500代表服务器内部错误
		if(xmlHttp.status==200){
			//交互成功，获得响应数据，是文本格式
			var result = xmlHttp.responseText
			//解析获得的数据
			var json = eval("("+result+")");
			//获得数据之后，就可以动态的展示这些数据，把这些数据展示到输入框的下面
			//alert(json);
			setContent(json);
		}
	}
	
}

//设置关联数据的展示,参数是服务器传递过来的关联数据
function setContent(contents){
	
	//输入前先清空数据
	clearContent();
	
	
	//首先确定服务器传递过来数据的长度，以此设定tbody中的tr和td的数量
	var size = contents.length;
	if(size<=0){
		return;
	}else{
		//在tbody中设置关联数据前，先设定tbody显示的位置（大小，长宽高等）
		setLocation();
		//设置tbody中的内容
		for(var i=0;i<size;i++){
			
			var nextNode = contents[i];//代表json格式数据中的第i个元素
			var tr = document.createElement("tr");
			var td = document.createElement("td");
			td.setAttribute("border", "0");
			td.setAttribute("bgcolor", "#FFFAFA");
			td.onmouseover = function(){
				this.className='mouseOver';
			};
			td.onmouseout = function(){
				this.className='mouseOut';
			};
			//当鼠标点击一个关联数据时，自动将该条数据填充到输入框当中
			//td.onclick = function(){			
			//	this.document.getElementById("command_text").value="haha";
			//};
			td.onmousedown = function(){
               document.getElementById("command_text").value =this.innerText;
          	};
			
			var text = document.createTextNode(nextNode);
			td.appendChild(text);
			tr.appendChild(td);
			document.getElementById("content_table_body").appendChild(tr);
		}
	}
	
}

//清空tbody中之前的数据
function clearContent(){
	
	var contentTableBody = document.getElementById("content_table_body");
	var size = contentTableBody.childNodes.length;
	for(var i=size-1;i>=0;i--){
		contentTableBody.removeChild(contentTableBody.childNodes[i]);
	}
	document.getElementById("popDiv").style.border="none";
}

//设置显示关联信息的位置
function setLocation(){
	
	//关联信息的显示位置要和输入框一致
	var content = document.getElementById("command_text");
	var width = content.offsetWidth;//输入框的宽度
	var left = content["offsetLeft"];//到左边框的距离
	var top = content["offsetTop"]+content.offsetHeight;//到输入框顶部的距离
	//获得显示数据的div
	var popDiv = document.getElementById("popDiv");
	popDiv.style.border="black 1px solid";
	popDiv.style.left=left+"px";
	popDiv.style.top=top+"px";
	popDiv.style.width=width+"px";
	
	document.getElementById("content_table").style.width=width+"px";
}

//当输入框失去焦点的时候清空数据
function keywordBlur(){
	clearContent();
}

//创建ajax的XMLHttpRequest对象
function createXMLHttpRequest(){
	
	var xmlHttp;
	//对于大多数浏览器这种方法适用
	if(window.XMLHttpRequest){
		xmlHttp = new XMLHttpRequest();
	}else if(window.ActiveXObject){//考虑到（老版本）浏览器的兼容性
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		if(!xmlHttp){
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		}
	}
	return xmlHttp;
}
</script>
</head>
<body>
<div id="myDiv">
	<!-- 输入框 -->
	<input type="text"   name="command" id="command_text" onkeyup="showMoreContent()" onblur="keywordBlur()" onfocus="showMoreContent()"/>
	<input type="button" name="submit"  id="mybutton" value="搜索一下"/>
	<div id="popDiv">
		<table id="content_table" bgcolor="#FFFAFA" border="0" cellpadding="0" cellspacing="0">
			<!-- 动态展示相关词条 -->
			<tbody id="content_table_body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>