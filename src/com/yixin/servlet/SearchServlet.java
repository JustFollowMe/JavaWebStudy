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

	//����һЩģ��Ĺ�������
	public static List<String> datas = new ArrayList<String>();
	static{
		
		datas.add("ajax josn");
		datas.add("ajax2");
		datas.add("ajax3");
		datas.add("bench");
		datas.add("jack");
		datas.add("mike");
		datas.add("ajaxʹ��");
		datas.add("ajax�̳�");
		datas.add("ajax�÷�");
		datas.add("ajax�鼮");
		datas.add("ajax�ŵ�");
		datas.add("ajaxȱ��");
		datas.add("����");
		datas.add("˵��ɶ��");
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//���ñ����ʽ��ֹ��������
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		//��ȡ�û�����Ĺؼ���
		String keyword = request.getParameter("keyword");
		keyword = URLDecoder.decode(keyword,"utf-8");
		
		if(keyword!=null&&!"".equals(keyword)){
			//��ùؼ��ֺ���д����õ������Ĵ���
			List<String> listData = getAssociateWord(keyword);
			//����json��ʽ����
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
	 *��ȡ��keyword������Ĵ��� 
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
