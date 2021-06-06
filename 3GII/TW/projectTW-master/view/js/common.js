function vote(incidentId, positively) {
	let body = new FormData();
	
	body.append('incidentId', incidentId);
	body.append('positively', positively);
	
	fetch(window.location.protocol + "//" + window.location.hostname + ":" + location.port + "/vote.php", {
		method: 'POST',
		body: body
	}).then((res) => {
		res.json();
	}).then((json) => {
		console.log(`Respuesta: ${json}`);
	});
}

function deleteInServer(id, file) {
	let body = new FormData();
	let path = window.location.protocol + "//" + window.location.hostname + ":" + location.port + "/" + file + ".php";
	
	body.append('action', 'delete');
	body.append('id', id);
	
	console.log(`Path: ${path}`);
	
	fetch(path, {
		method: 'POST',
		body: body
	}).then((res) => {
		return res.json();
	}).then((json) => {
		console.log(json);
		if(json.code === "0") {
			location.reload();
		} else {
			console.log(`Code: ${json.code}`);
			console.log(`Message: ${json.message}`);
		}
	});
}

function deleteIncident(incidentId) {
	deleteInServer(incidentId, "incident");
}

function deleteUser(userId) {
	deleteInServer(userId, "user");
}
