var exportUrl = networkUrl;

editSogouUrl=campaignUpdateUrl;
editThreesixtiesUrl=editSogouUrl;
editBaiduUrl=editSogouUrl;
editShenmaUrl=editSogouUrl;

var aoColumns = [];
for(var i=0;i<15;i++){
	// aoColumns.push({ "asSorting": [ "desc", "asc" ] });
}


$('#networks-table thead tr th').each(function() {
	
	var show_class = $(this).attr("class");
	
	if (show_class != null && show_class.indexOf("js-sort-show") >= 0){
		aoColumns.push({ "asSorting": [ "desc", "asc" ] });	
	}
	
	
})

var networksDataTableOptions = {
	// bFilter: false,
	/* http://datatables.net/release-datatables/examples/basic_init/dom.html */
	"sDom": '<"table-responsive"rt>pil',
	"aLengthMenu": page_option,
	"language": {
		"info": "Page _PAGE_ of _PAGES_",
		"lengthMenu": "No. of Rows: _MENU_",
		"paginate": {
			"previous": "<<",
			"next": ">>"
		},
		"emptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"oLanguage": {
		"sInfo": "Page _PAGE_ of _PAGES_",
		"sLengthMenu": "No. of Rows: _MENU_",
		"oPaginate": {
			"sPrevious": "<<",
			"sNext": ">>"
		},
		"sEmptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"processing": true,
	"serverSide": true,
	"ajax": {
		"url":exportUrl,
		"type":"POST",
		"data": function(d){
			var filter_object=[];

			$(".filter_row").each(function(){
				if($(this).find("[name=field_value]").val()!=''){
					var filter={};

					filter.name=$(this).find("[name=field_name]").val();
					filter.rule=$(this).find("[name=field_rule]").val();
					filter.value=$(this).find("[name=field_value]").val();

					filter_object.push(filter);
				}
			});

			d.filter_object = filter_object;
			d.channel_array = $("input[name^=channel_array]:checked").map(function(){ return $(this).val(); }).get();
			d.account_array = $("input[name^=account_array]:checked").map(function(){ return $(this).val(); }).get();
			d.start_date = $("#start_date").val();
			d.end_date = $("#end_date").val();
			d.csv=0;

			exportData=d;

			return d;
		}
	},
	"fnDrawCallback": function( oSettings ) {
		
		
		var response = this.api().ajax.json();
		var all_conversion_business_type = response.all_conversion_business_type;
		var return_conversion_array_total = response.return_conversion_array_total;
		
		
		$.each(return_conversion_array_total, function(key,valueObj){
			$('#'+key+"_total").replaceWith('<th class="'+key+'" id="'+key+'_total">'+accounting.formatNumber(valueObj,2)+'</th>');
		});
		
		
		$('#networks-table thead tr th').each(function(index ) {
       		
       		th_this = $(this);
       		
       		class_str = th_this.attr('class');
       		class_str_arr = class_str.split(" ");
       		
       		
       		
       		
       		
       		class_str_arr.forEach(function(class_str_arr_d) {
       			correct_html_index = index + 1
				if(all_conversion_business_type.includes(class_str_arr_d)){
	       			// console.log("sad_ "+index+"_"+class_str_arr_d);
	       			
	       				       			
					$('#campaigns-table tbody td:nth-child('+correct_html_index+')').addClass(class_str_arr_d);	       			
	       		}    
			});
       	});
       	
       	
       	$('.switch_conversion_type').each(function(index ) {
			
			if($(this).is(':checked') == true){
	        	$("."+$(this).val()).show();
	        	$("."+$(this).val()+"revenue").show();
	        }else{
	        	$("."+$(this).val()).hide();
	        	$("."+$(this).val()+"revenue").hide();
	        } 
			
		}); 
		 
		 
		$('.switch_conversion_type').change(function() {
	        // $(this).val($(this).is(':checked'));
	        // console.log($(this).val());       
	        // console.log($(this).is(':checked'));
	        
	        if($(this).is(':checked') == true){
	        	$("."+$(this).val()).show();
	        	$("."+$(this).val()+"revenue").show();
	        }else{
	        	$("."+$(this).val()).hide();
	        	$("."+$(this).val()+"revenue").hide();
	        } 
	    });
	    
	    
	    $.each(all_conversion_business_type, function(key,valueObj){
			// console.log(valueObj);
			
			$('td.'+valueObj).each(function(index ) {
				td_this = $(this);
				td_this.text(accounting.formatNumber(td_this.text(),2));
				
			});		
			
		});	
		
		
		
		$(".selectAllPageRecordContainer").remove();
		$("#select_all").attr('checked', false);
		$(".loading_container").hide();
		tableTopScrollbar();
		pageTotalRecord=oSettings.json.data.length;
		allPageTotalRecord=oSettings.json.recordsTotal;

		//leon start 170328
           $("#networks-table").colResizable({
               partialRefresh: true,
							 liveDrag: true,
               resizeMode: 'overflow'
           });
           //leon end 170328
    },
    "fnFooterCallback": function (nFoot, aData, mData, iStart, iEnd, aiDisplay) {

    	 var response = this.api().ajax.json();

    	 console.log(response);
    	 console.log(nFoot.getElementsByTagName('th'));

    	 nFoot.getElementsByTagName('th')[0].innerHTML = "Total of all "+response.total_count+" accounts";
    	 nFoot.getElementsByTagName('th')[2].innerHTML = accounting.formatNumber(response.total[3]);
    	 nFoot.getElementsByTagName('th')[3].innerHTML = accounting.formatNumber(response.total[4]);
    	 nFoot.getElementsByTagName('th')[4].innerHTML = accounting.formatNumber(response.total[5]);
    	 nFoot.getElementsByTagName('th')[5].innerHTML = accounting.formatNumber(response.total[6],2)+"%";
    	 nFoot.getElementsByTagName('th')[6].innerHTML = accounting.formatNumber(response.total[7]);
    	 nFoot.getElementsByTagName('th')[7].innerHTML = accounting.formatNumber(response.total[8],2)+"%";
    	 nFoot.getElementsByTagName('th')[8].innerHTML = accounting.formatNumber(response.total[9],2);
    	 nFoot.getElementsByTagName('th')[9].innerHTML = accounting.formatNumber(response.total[13],2);

    },
	"columnDefs": [
		{
            "render": function ( data, type, row ) {
            	if(row[11] == 1){
            		return '<div class="text-left checkbox"><label><input type="checkbox" name="id[]" value="'+row[0]+"_"+row[2].toLowerCase()+'"><a href="'+ row[10] +'">'+data+'</a>  (Last Sync : '+row[12]+')</label></div>';
            	}else{
            		return '<div class="text-left checkbox"><img style="margin-right:8px;" width="22" src="/images/icon/loading-x.gif"><a href="'+ row[10] +'">'+data+'</a></div>';
            	}

            },
            "targets": [1]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data);
            },
            "targets": [3,4,5,7]
        },

        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2)+"%";
            },
            "targets": [6,8]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2);
            },
            "targets": [9,13]
        }
        /*
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left"><a href="'+ row[3] +'">'+ data +'</a></div>';
            },
            "targets": [2]
        },
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left">'+ data +'</div>';
            },
            "targets": [4,5,6]
        },
		*/

        ,{ "visible": false,  "targets": [0,10,11,12] },
        { "orderable": false, "targets": [1]}

    ]
    ,
    "order": [[ 3, "desc" ]],
    "aoColumns": aoColumns

}

var networkTable;

$(document).ready(function(){
	if(/\/campaigns\/threesixty/i.test(window.location.href)){
		switchToNetwork('qihoo_360');
	}
	else if(/\/campaigns\/sogou/i.test(window.location.href)){
		switchToNetwork('sogou');
	}
	else if(/\/campaigns\/baidu/i.test(window.location.href)){
		switchToNetwork('baidu');
	}else if(/\/campaigns\/shenma/i.test(window.location.href)){
		switchToNetwork('shenma');
	}

	networkTable = $("#networks-table").on('preXhr.dt', function(e,settings,data){
		$(".loading_container").show();
	}).DataTable(networksDataTableOptions);

	// datatable filters
	// prevent defautl sorting click event
	$("th").on("click selectstart", ".dropdown-menu", function(e){
		e.stopPropagation();
	});
	$("th").on("click selectstart", "input[type=checkbox]", function(e){
		e.stopPropagation();
	});

	// reset chosen
	// $('.dropdown').one('show.bs.dropdown', function (e) {
		// $(this).find("select").chosen('destroy');
	// });
	// $('.dropdown').one('shown.bs.dropdown', function (e) {
		// $(this).find("select").chosen({disable_search:true});
	// });
	// bind search event to filterText fieid
	networkTable.columns().every(function(){
		var column = this;
		$('input.filterText', this.header()).on('change', function(){
			column.search(this.value).draw();
		});
	});


	// $("table").colResizable({resizeMode:'overflow'});


});

function switchToNetwork(network){
	$("[name^=channel_array]").prop('checked', false);
	$("#"+network).prop('checked', true);
}

function getNetworkData(){
	networkTable.draw();

}
