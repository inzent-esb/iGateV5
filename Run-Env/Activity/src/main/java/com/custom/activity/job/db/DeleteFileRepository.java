package com.custom.activity.job.db;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.orm.hibernate5.HibernateCallback;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.transaction.annotation.Transactional;

import com.inzent.igate.context.Context;
import com.inzent.igate.repository.meta.Activity;
import com.inzent.igate.rule.activity.AbstractActivity;

public class DeleteFileRepository extends AbstractActivity {

	private final HibernateTemplate logTemplate;	

	public DeleteFileRepository(Activity activity) {
		super(activity);
		logTemplate = (HibernateTemplate) Context.getApplicationContext().getBean("logTemplate") ;
	}

	@Transactional
	@Override
	public int execute(Object... args) throws Throwable 
	{		

		final String fileName = (String)args[0];
		final boolean where = fileName ==null ? false : (fileName.isEmpty() ? false : true);
		final String queryString = where ? 
				String.format("DELETE FROM FileRepository WHERE pk.fileName = '%s'", fileName) 
				: "DELETE FROM FileRepository " ;

		if (logger.isInfoEnabled() )
		{
			logger.info("## fileName :" + fileName);
			logger.info("## where :" + where);
			logger.info("## " + queryString);
		}

		logTemplate.execute(new HibernateCallback<Object>()
		{
			@Override
			public Object doInHibernate(Session session) throws HibernateException {

				Transaction tx = session.beginTransaction();
				//int rowCount = session.createQuery(queryString.toString()).setParameter("fileName", fileName).executeUpdate();
				int rowCount = session.createQuery(queryString.toString()).executeUpdate();
				tx.commit();

				if (logger.isInfoEnabled() )
					logger.info((rowCount == 0) ? "fail" : "success");
				
				return null;
			}
		}) ;
		return 0;
	}

	@Override
	public boolean isSingleton() {
		return false;
	}

}
