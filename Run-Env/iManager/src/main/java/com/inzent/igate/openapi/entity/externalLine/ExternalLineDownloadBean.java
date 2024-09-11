package com.inzent.igate.openapi.entity.externalLine;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import com.inzent.igate.repository.meta.ExternalLine;

public interface ExternalLineDownloadBean {
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, ExternalLine entity, List<ExternalLine> entityList) throws Exception;

	
}
