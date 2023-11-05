
export interface Env {
	// Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
	// MY_KV_NAMESPACE: KVNamespace;
	//
	// Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
	// MY_DURABLE_OBJECT: DurableObjectNamespace;
	//
	// Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
	// MY_BUCKET: R2Bucket;
	//
	// Example binding to a Service. Learn more at https://developers.cloudflare.com/workers/runtime-apis/service-bindings/
	// MY_SERVICE: Fetcher;
	//
	// Example binding to a Queue. Learn more at https://developers.cloudflare.com/queues/javascript-apis/
	// MY_QUEUE: Queue;
}
addEventListener('fetch', (event) => {
	event.respondWith(handleRequest(event.request));
  });
  
  async function handleRequest(request) {
	const clientIP = request.headers.get('cf-connecting-ip');
	const country = request.headers.get('cf-ipcountry');
	let asn = null;
  
	// Fetch ASN information from an external service
	try {
	  const ipInfoResponse = await fetch(`https://ipinfo.io/${clientIP}/org`);
	  if (ipInfoResponse.ok) {
		const asnInfo = await ipInfoResponse.text();
		asn = asnInfo.trim();
	  }
	} catch (error) {
	  console.error('Error fetching ASN information:', error);
	}
  
	if (country === 'SN') {
	  // User is not from Singapore, return HTML response
	  const responseText = `
		<html>
		  <body>
			This is  ${clientIP} and you are accessing this site from ${country} | ${asn || 'ASN information not available'}.
		  </body>
		</html>
	  `;
  
	  return new Response(responseText, {
		status: 200,
		headers: {
		  'Content-Type': 'text/html',
		},
	  });
	} else {
	  // User is from Singapore, redirect to a URL with a 302 status code
	  return Response.redirect('https://1.1.1.1/', 302 );
	}
  }
  
