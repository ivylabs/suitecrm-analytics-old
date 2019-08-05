define(['cdf/lib/jquery'], function($) {
var analytics = {}

    analytics.objs = {
        
        projectName:"SuiteCRM",
        projectRootDir:"suitecrm",
        defaultChartColors:["#FF0000","#00FF00","#0000FF"]
        
    }

    analytics.functions = {
        
        resizeChart:function(dash){ 
            for(var z = 0; z < dash.components.length; z++){
                if(dash.components[z].type.indexOf("Ccc")!=-1 && dash.components[z].chart !== null){
                    dash.components[z].chart.options.width=$("#"+dash.components[z].htmlObject).width();
                    dash.components[z].chart.render(true,true,false);
                }
            }
        },
        
        sayHello:function(name){
            alert("Hello "+name);
        },
        
        sayHelloUser:function(dash){
            alert("hello "+dash.context.user);
        },
        
        printHello:function(name){
            return "Hello"+name;
        },
        
        sampleDotExtensionPointFunction:function(dash,cd){
            cd.dot_visible = function(scene){
                if(scene.getCategory == "TEST"){
                    return true;
                } else {
                    return false;
                }
            }
        },
        
        sampleBarExtensionPointFunction:function(dash,cd){
            cd.bar_fillStyle = function(scene){
                if(scene.getCategory() == "Email"){
                    return "blue";
                } else {
                    return "grey"
                }
            }
        },
        
        customLineWidth:function(dash,cd){
          
          cd.line_lineWidth = function(scene){
              return 10;  
          }
        },
        
        refireChart:function(cd, dash,datasource,i){
            setTimeout(dash.getComponentByName(cd.name).render(datasource), 1000);
        },
        
        generateLiveData:function(cd,dash){
            
            var datasource = cd.query.lastResults();
            
            var myCount = 7, newResultSet = [];

            for (i = 2; i < myCount; i++) { 
                
                datasource.resultset.push([datasource.resultset.length+1,Math.random()*20]);
                
                console.log(JSON.stringify(datasource));
                
                //dash.getComponentByName(cd.name).render(datasource)
                
                analytics.functions.refireChart(cd,dash,datasource,i);
                
            }
        }
        
    }
    
    analytics.opts = {
        
        charts:{
            
            defaultChartComp:{
                height:400
            },
            
            sampleChart1:{
                height:800,
                colors: ["#ff0000","00ff00","0000ff"]
            },
            
            overviewLineWidget:{
                dot_fillStyle:function(scene){
                    
                    var color = "#ffffff";
                    
                    if(!scene.nextSibling) {
                        color = "#00a65a";
                    }
                    
                    return color;
                },
                
                dot_visible:function(scene){
                    
                    var renderDot = false;
                    
                    if(!scene.nextSibling) {
                        renderDot = true;
                    }
                    
                    return renderDot;
                },
                
                dot_lineWidth:2,
                dot_strokeStyle: "#FFF",
                line_lineWidth:2,
                dot_shapeRadius:5,
                contentPaddings:10,
                titleSize:0,
                line_strokeStyle: "#CCC"
            }
            
        },
        
        tables:{
            T1Table:{
                colHeaders:["AAA","BBB","CCC"]
            }
        }
    }
    
    return analytics;
});