package com.yixin.servlet;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

@SuppressWarnings("serial")
public class SearchServlet extends HttpServlet{

	//设置一些模拟的关联数据
	public static List<String> datas = new ArrayList<String>();
	static{
		
		datas.add("ajax josn");
		datas.add("ajax2");
		datas.add("ajax3");
		datas.add("bench");
		datas.add("jack");
		datas.add("mike");
		datas.add("ajax使用");
		datas.add("ajax教程");
		datas.add("ajax用法");
		datas.add("ajax书籍");
		datas.add("ajax优点");
		datas.add("ajax缺点");
		datas.add("其他");
		datas.add("说点啥呢");
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//设置编码格式防止中文乱码
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		//获取用户输入的关键字
		String keyword = request.getParameter("keyword");
		keyword = URLDecoder.decode(keyword,"utf-8");
		
		if(keyword!=null&&!"".equals(keyword)){
			//获得关键字后进行处理，得到关联的词条
			List<String> listData = getAssociateWord(keyword);
			//返回json格式数据
			JSONArray json = JSONArray.fromObject(listData);
			System.out.println(json.toString());
			response.getWriter().write(json.toString());
		}else{
			System.out.println("[]");
			response.getWriter().write("[]");
		}
		
		
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	/*
	 *获取和keyword相关联的词条 
	 */
	public static List<String> getAssociateWord(String keyword){
		
		List<String> list = new ArrayList<String>();
		
		for(String data:datas){
			if(data.contains(keyword)){
				list.add(data);
			}
		}
		return list;
	}
}
