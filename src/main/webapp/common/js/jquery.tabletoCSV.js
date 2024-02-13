jQuery.fn.tableToCSV = function() {
    
    var clean_text = function(text){
        text = text.replace(/"/g, '\\"').replace(/'/g, "\\'").replace(/\s/g, '' );
        return '"'+text+'"';
    };
    
	$(this).each(function(){
			var table = $(this);
			var caption = $(this).find('caption').text();
			var title = [];
			var rows = [];
			var groupedHeader=true;
			$(this).find('tr').each(function(){
				if(groupedHeader){
					groupedHeader=false;
				}else{
				var data = [];
				$(this).find('th').each(function(){
                    var text = clean_text($(this).text());
					title.push(text);
					});
				$(this).find('td').each(function(){
                    var text = clean_text($(this).text());
                  //  console.log("TEXT:" +text);
					data.push(text);
					});
				data = data.join(",");
				rows.push(data);
				}});
			title = title.join(",");
			rows = rows.join("\n");
			//console.log("ROWS:"+ rows)
			var fileCitation = document.getElementById("fileCitation").innerHTML;
			var csv = fileCitation + "\n" + title + rows;
			var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
			var download_link = document.createElement('a');
			download_link.href = uri;
			var ts = new Date().getTime();
			if(caption==""){
				download_link.download =ts+".csv";
			} else {
				download_link.download = caption+"-"+ts+".csv";
			}
			document.body.appendChild(download_link);
			download_link.click();
			document.body.removeChild(download_link);
	});

};

jQuery.fn.tableSelectionToCSV = function() {

	var clean_text = function(text){
		text = text.replace(/"/g, '\\"').replace(/'/g, "\\'");
		return '"'+text+'"';
	};
	var groupedHeader=true;
	$(this).each(function(){
		var table = $(this);
		var caption = $(this).find('caption').text();
		var title = [];
		var rows = [];

		$(this).find('tr').each(function(){
			if (this.style.display === "none") {
				return;
			}
			if(groupedHeader){
			groupedHeader=false;
			}else {
				var data = [];
				$(this).find('th').each(function () {
					var text = clean_text($(this).text());
					title.push(text);
				});
				$(this).find('td').each(function () {
					var text = clean_text($(this).text());
					data.push(text);
				});
				data = data.join(",");
				rows.push(data);
		}
		});
		title = title.join(",");
		rows = rows.join("\n");

		var fileCitation = document.getElementById("fileCitation").innerHTML;
		var csv = fileCitation + "\n" + title + rows;
		var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
		var download_link = document.createElement('a');
		download_link.href = uri;
		var ts = new Date().getTime();
		if(caption==""){
			download_link.download = ts+".csv";
		} else {
			download_link.download = caption+"-"+ts+".csv";
		}
		document.body.appendChild(download_link);
		download_link.click();
		document.body.removeChild(download_link);
	});

};