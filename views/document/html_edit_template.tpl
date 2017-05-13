<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>编辑文档 - Powered by MinDoc</title>

    <script type="text/javascript">
        window.editor = null;
        window.imageUploadURL = "{{urlfor "DocumentController.Upload" "identify" .Model.Identify}}";
        window.fileUploadURL = "{{urlfor "DocumentController.Upload" "identify" .Model.Identify}}";
        window.documentCategory = {{.Result}};
        window.book = {{.ModelResult}};
        window.selectNode = null;
        window.deleteURL = "{{urlfor "DocumentController.Delete" ":key" .Model.Identify}}";
        window.editURL = "{{urlfor "DocumentController.Content" ":key" .Model.Identify ":id" ""}}";
        window.releaseURL = "{{urlfor "BookController.Release" ":key" .Model.Identify}}";
        window.sortURL = "{{urlfor "BookController.SaveSort" ":key" .Model.Identify}}";
        window.baiduMapKey = "{{.BaiDuMapKey}}";

        window.vueApp = null;
    </script>
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/jstree/3.3.4/themes/default/style.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/wangEditor/css/wangEditor.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/highlight/styles/zenburn.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/webuploader/webuploader.css"}}" rel="stylesheet">

    <link href="/static/css/jstree.css" rel="stylesheet">
    <link href="/static/css/markdown.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="/static/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="/static/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>

<div class="m-manual manual-editor">
    <!--{{/*<div class="manual-head" id="editormd-tools">
        <div class="editormd-group">
            <a href="{{urlfor "BookController.Dashboard" ":key" .Model.Identify}}" data-toggle="tooltip" data-title="返回"><i class="fa fa-chevron-left" aria-hidden="true"></i></a>
        </div>
        <div class="editormd-group">
            <a href="javascript:;" id="markdown-save" data-toggle="tooltip" data-title="保存" class="disabled save"><i class="fa fa-save" aria-hidden="true" name="save"></i></a>
        </div>


        <div class="editormd-group">
            <a href="javascript:;" data-toggle="tooltip" data-title="修改历史"><i class="fa fa-history item" name="history" aria-hidden="true"></i></a>
            <a href="javascript:;" data-toggle="tooltip" data-title="边栏"><i class="fa fa-columns item" aria-hidden="true" name="sidebar"></i></a>
            <a href="javascript:;" data-toggle="tooltip" data-title="使用帮助"><i class="fa fa-question-circle-o last" aria-hidden="true" name="help"></i></a>
        </div>

        <div class="editormd-group">
            <a href="javascript:;" data-toggle="tooltip" data-title="发布"><i class="fa fa-cloud-upload" name="release" aria-hidden="true"></i></a>
        </div>

        <div class="editormd-group">
            <a href="javascript:;" data-toggle="tooltip" data-title=""></a>
            <a href="javascript:;" data-toggle="tooltip" data-title=""></a>
        </div>

        <div class="clearfix"></div>
    </div>*/}}-->
    <div class="manual-body">
        <div class="manual-category" id="manualCategory" style="top: 0;">
            <div class="manual-nav">
                <div class="nav-item active"><i class="fa fa-bars" aria-hidden="true"></i> 目录</div>
                <div class="nav-plus pull-right" id="btnAddDocument" data-toggle="tooltip" data-title="创建目录" data-direction="right"><i class="fa fa-plus" aria-hidden="true"></i></div>
                <div class="clearfix"></div>
            </div>
            <div class="manual-tree" id="sidebar">

            </div>
        </div>
        <div class="manual-editor-container" id="manualEditorContainer" style="top: 0;">
            <div class="manual-wangEditor">
                <div id="htmlEditor" class="manual-editormd-active" style="height: 100%"></div>
            </div>
            <div class="manual-editor-status">
                <div id="attachInfo" class="item"></div>
            </div>
        </div>

    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="addDocumentModal" tabindex="-1" role="dialog" aria-labelledby="addDocumentModalLabel">
    <div class="modal-dialog" role="document">
        <form method="post" action="{{urlfor "DocumentController.Create" ":key" .Model.Identify}}" id="addDocumentForm" class="form-horizontal">
            <input type="hidden" name="identify" value="{{.Model.Identify}}">
            <input type="hidden" name="doc_id" value="0">
            <input type="hidden" name="parent_id" value="0">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">添加目录</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">目录名称 <span class="error-message">*</span></label>
                        <div class="col-sm-10">
                            <input type="text" name="doc_name" id="documentName" placeholder="目录名称" class="form-control"  maxlength="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">目录标识</label>
                        <div class="col-sm-10">
                            <input type="text" name="doc_identify" id="documentIdentify" placeholder="目录唯一标识" class="form-control" maxlength="50">
                            <p style="color: #999;font-size: 12px;">文档标识只能包含小写字母、数字，以及“-”和“_”符号,并且只能小写字母开头</p>
                        </div>

                    </div>
                </div>
                <div class="modal-footer">
                    <span id="add-error-message" class="error-message"></span>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary" id="btnSaveDocument" data-loading-text="保存中...">立即保存</button>
                </div>
            </div>
        </form>
    </div>
</div>
<div class="modal fade" id="uploadAttachModal" tabindex="-1" role="dialog" aria-labelledby="uploadAttachModalLabel">
    <div class="modal-dialog" role="document">
        <form method="post" action="{{urlfor "DocumentController.Create" ":key" .Model.Identify}}" id="addDocumentForm" class="form-horizontal">
            <input type="hidden" name="identify" value="{{.Model.Identify}}">
            <input type="hidden" name="doc_id" value="0">
            <input type="hidden" name="parent_id" value="0">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">上传附件</h4>
                </div>
                <div class="modal-body">
                    <div class="attach-drop-panel">
                        <div class="upload-container" id="filePicker"><i class="fa fa-upload" aria-hidden="true"></i></div>
                    </div>
                    <div class="attach-list" id="attachList">
                        <template v-for="item in lists">
                            <div class="attach-item">
                                <template v-if="item.state == 0">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100">
                                            <span class="sr-only">0% Complete (success)</span>
                                        </div>
                                    </div>
                                </template>
                                <template v-else>
                                    <input type="hidden" name="attach_id[0]" :value="item.attach_id">
                                    <input type="text" class="form-control" placeholder="附件名称" :value="item.file_name">
                                    <span class="text">(${(item.file_size/1024/1024).toFixed(4)}MB)</span>
                                    <span class="error-message">${item.message}</span>
                                    <button type="button" class="btn btn-sm close" @click="removeAttach(item.attachment_id)">
                                        <i class="fa fa-remove" aria-hidden="true"></i>
                                    </button>
                                    <div class="clearfix"></div>
                                </template>
                            </div>
                        </template>
                    </div>
                </div>
                <div class="modal-footer">
                    <span id="add-error-message" class="error-message"></span>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnUploadAttachFile">确定</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}"></script>
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}"></script>
<script src="{{cdnjs "/static/vuejs/vue.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/jstree/3.3.4/jstree.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/webuploader/webuploader.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/wangEditor/js/wangEditor.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/wangEditor/plugins/save-menu.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/wangEditor/plugins/release-menu.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/wangEditor/plugins/attach-menu.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/layer/layer.js"}}" type="text/javascript" ></script>
<script src="{{cdnjs "/static/to-markdown/dist/to-markdown.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/js/jquery.form.js"}}" type="text/javascript"></script>
<script type="text/javascript">
    window.vueApp = new Vue({
        el : "#attachList",
        data : {
            lists : []
        },
        delimiters : ['${','}'],
        methods : {
            removeAttach : function ($attach_id) {
                console.log($attach_id);
                var $this = this;
                $.ajax({
                    url : "{{urlfor "DocumentController.RemoveAttachment"}}",
                    type : "post",
                    data : { "attach_id" : $attach_id},
                    success : function (res) {
                        console.log(res);
                        if(res.errcode === 0){
                            for(var i in $this.lists){
                                var item = $this.lists[i];
                                if (item.attachment_id == res.data.attachment_id){
                                    $this.lists.$remove(item);
                                    break;
                                }
                            }
                        }else{
                            layer.msg(res.message);
                        }
                    }
                });
            }
        }
    });
</script>
<script src="/static/js/editor.js" type="text/javascript"></script>
<script src="/static/js/html-editor.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        $("#attachInfo").on("click",function () {
            $("#uploadAttachModal").modal("show");
        });

        window.uploader = null;

        $("#uploadAttachModal").on("shown.bs.modal",function () {
            if(window.uploader === null){
                try {
                    window.uploader = WebUploader.create({
                        auto: true,
                        dnd : true,
                        swf: '/static/webuploader/Uploader.swf',
                        server: '{{urlfor "DocumentController.Upload"}}',
                        formData : { "identify" : {{.Model.Identify}},"doc_id" :  window.selectNode.id },
                        pick: "#filePicker",
                        fileVal : "editormd-file-file",
                        fileNumLimit : 1,
                        compress : false
                    }).on("beforeFileQueued",function (file) {
                        uploader.reset();
                    }).on( 'fileQueued', function( file ) {
                       var item = {
                           state : 0,
                           attachment_id : file.id,
                           file_size : file.size,
                           file_name : file.name,
                           message : "正在上传"
                       };
                       window.vueApp.lists.splice(0,0,item);

                    }).on("uploadError",function (file,reason) {
                        $("#error-message").text("上传失败:" + reason);

                    }).on("uploadSuccess",function (file, res) {
                        console.log(file);

                        for(var index in window.vueApp.lists){
                            var item = window.vueApp.lists[index];
                            if(item.id === file.id()){
                                window.vueApp.lists.splice(index,1,res.attach);
                                break;
                            }
                        }

                    }).on("beforeFileQueued",function (file) {

                    }).on("uploadComplete",function () {

                    }).on("uploadProgress",function (file, percentage) {
                        var $li = $( '#'+file.id ),
                            $percent = $li.find('.progress .progress-bar');

                        $percent.css( 'width', percentage * 100 + '%' );
                    });
                }catch(e){
                    console.log(e);
                }
            }
        });


    });
</script>
</body>
</html>