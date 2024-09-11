package com.inzent.igate.openapi.entity.externalLine;

import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.inzent.igate.imanager.Privileges;
import com.inzent.igate.openapi.entity.externalline.ExternalLineService;
import com.inzent.igate.repository.meta.ExternalLine;
import com.inzent.imanager.common.CommonMessage;
import com.inzent.imanager.controller.MetaEntityController;
import com.inzent.imanager.marshaller.JsonMarshaller;
import com.inzent.imanager.message.MessageLog;

@Controller
@RequestMapping(ExternalLineExcelController.URI)
public class ExternalLineExcelController extends MetaEntityController<String, ExternalLine> {
	public static final String URI = "/api/entity/externalLineExcel";

	public static final String PATH_DOWNLOAD = "/download";
	public static final String PATH_APPLY_META = "/applyMeta";
	public static final String PATH_DOCUMENT = "/document";

	@Autowired
	protected ExternalLineDownloadBean downloadBean;

	@Autowired
	protected ExternalLineUploadBean uploadBean;

	public ExternalLineExcelController() {
		super(ExternalLine.class, Privileges.EXTERNAL_LINE_EDITOR);
	}

	@Autowired
	@Qualifier("externalLineService")
	public void setExternalLineService(ExternalLineService externalLineService) {
		setMetaEntityService(externalLineService);
	}

	@GetMapping(PATH_DOWNLOAD)
	public void downloadList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		try {
			JsonNode jsonNode = JsonMarshaller.objectMapper.readTree(request.getInputStream());
			ExternalLine entity = unformalize(JsonMarshaller.unmarshal(jsonNode.get("object"), entityClass));

			if (logger.isInfoEnabled())
				MessageLog.info(logger, CommonMessage.DAO_EXCEL_EXPORT, CommonMessage.DAO_EXCEL_EXPORT_MESSAGE,
						httpSession.getUserId(), httpSession.getRemote(), entity.getClass().getSimpleName(),
						JsonMarshaller.dumpObject(entity));

			List<ExternalLine> list = new LinkedList<>();
			for (ExternalLine externalLine : entityService.search(entity, -1, null, jsonNode.get("reverseOrder").asBoolean(false)))
				list.add(entityService.get(entityService.getKey(externalLine)));

			downloadBean.downloadFile(request, response, entity, list);

		} catch (Throwable th) {
			if (logger.isErrorEnabled())
				logger.error(th.toString(), th);

			throw th;
		}

	}

	@PostMapping(PATH_DOCUMENT)
	public void excelUpload(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletResponse response) throws Exception {
		try {
			for(ExternalLine el : entityService.search(null, -1, null, false)) {
				ExternalLine el2 = entityService.get(el.getExternalLineId());
				if (null != el2) {					
					entityService.delete(el2);
				}
			}
			
			for (ExternalLine entity : uploadBean.getExcelUpload(uploadFile)) {
				ExternalLine entity2 = entityService.get(entity.getExternalLineId());
				if (null == entity2) {
					hasWritePermission(entity, true);

					if (logger.isInfoEnabled())
						MessageLog.info(logger, CommonMessage.DAO_CREATE, CommonMessage.DAO_CREATE_MESSAGE,
								httpSession.getUserId(), httpSession.getRemote(), entityClass.getSimpleName(),
								JsonMarshaller.dumpObject(entity));

					entityService.insert(entity);

					entityService.afterInserted(entity);
				} else {
					hasWritePermission(entity2, false);

					if (logger.isInfoEnabled())
						MessageLog.info(logger, CommonMessage.DAO_UPDATE, CommonMessage.DAO_UPDATE_MESSAGE,
								httpSession.getUserId(), httpSession.getRemote(), entityClass.getSimpleName(),
								JsonMarshaller.dumpObject(entity));

					Runnable runnable = entityService.update(entity, entity2);
					if (null != runnable)
						runnable.run();

					entityService.afterUpdated(entity, entity2);
				}
			}
			response.setStatus(200) ;
			
		} catch (Throwable th) {
			if (logger.isErrorEnabled())
				logger.error(th.toString(), th);
			response.setStatus(500) ;
		}
	}

}
