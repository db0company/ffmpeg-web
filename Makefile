# ffmpeg.org HTML generation from source files

SRCS = about bugreports consulting contact donations documentation download \
       olddownload index legal projects shame security archive

DEV = htdocs
PROD = dist

GLOBAL_DEPS = src/template_head1 src/template_head2 src/template_head3 \
              src/template_footer1 src/template_footer2

DEV_DEPS = $(GLOBAL_DEPS) src/template_head_dev src/template_footer_dev
PROD_DEPS = $(GLOBAL_DEPS) src/template_head_prod src/template_footer_prod

DEV_HTML_FILES  = $(addsuffix .html,$(addprefix $(DEV)/,$(SRCS)))
PROD_HTML_FILES = $(addsuffix .html,$(addprefix $(PROD)/,$(SRCS)))

BOWER_PACKAGES = bower.json
BOWER_COMPONENTS = $(DEV)/components

CSS_SRCS = $(DEV)/less/style.less
CSS_DIR = $(PROD)/css
CSS_TARGET = $(CSS_DIR)/style.min.css

RSS_FILENAME = main.rss
RSS_TARGET = $(DEV)/$(RSS_FILENAME)

DEV_TARGETS = $(BOWER_COMPONENTS) $(DEV_HTML_FILES) $(RSS_TARGET)
PROD_TARGETS = $(PROD_HTML_FILES) $(CSS_TARGET)

all: $(PROD)

dev: $(DEV_TARGETS)

$(PROD): dev $(PROD_TARGETS)
	@echo "Copy production files from development files"
	@cp $(RSS_TARGET) $(PROD)/
	@cp -r $(DEV)/js $(PROD)
	@cp -r $(DEV)/robots.txt $(PROD)
	@cp -r $(BOWER_COMPONENTS)/font-awesome/fonts $(PROD)
	@cp $(BOWER_COMPONENTS)/font-awesome/css/font-awesome.min.css $(CSS_DIR)/
	@cp $(BOWER_COMPONENTS)/bootstrap/dist/css/bootstrap.min.css $(CSS_DIR)/
	@cp $(BOWER_COMPONENTS)/bootstrap/dist/js/bootstrap.min.js $(PROD)/js/
	@cp $(BOWER_COMPONENTS)/jquery/dist/jquery.min.js $(PROD)/js/
	@cp $(DEV)/css/simple-sidebar.css $(CSS_DIR)/
	@mkdir -p $(PROD)/img/
	@cp $(DEV)/img/ffmpeg3d_white_20.png $(PROD)/img/
	@cp $(DEV)/img/favicon3d.ico $(PROD)/img/

$(DEV)/%.html: src/% src/%_title src/%_js $(DEV_DEPS)
	cat src/template_head1 $<_title src/template_head_dev \
	src/template_head2 $<_title src/template_head3 $< \
	src/template_footer1 src/template_footer_dev $<_js src/template_footer2 > $@

$(PROD)/%.html: src/% src/%_title src/%_js $(PROD_DEPS)
	@mkdir -p $(PROD)
	cat src/template_head1 $<_title src/template_head_prod \
	src/template_head2 $<_title src/template_head3 $< \
	src/template_footer1 src/template_footer_prod $<_js src/template_footer2 > $@

$(RSS_TARGET): $(DEV)/index.html
	echo '<?xml version="1.0" encoding="UTF-8" ?>' > $@
	echo '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">' >> $@
	echo '<channel>' >> $@
	echo '    <title>FFmpeg RSS</title>' >> $@
	echo '    <link>http://ffmpeg.org</link>' >> $@
	echo '    <description>FFmpeg RSS</description>' >> $@
	echo '    <atom:link href="http://ffmpeg.org/main.rss" rel="self" type="application/rss+xml" />' >> $@
	grep '<a *id=".*" *></a><h3>.*20..,.*</h3>' $< | sed 'sX<a *id="\(.*\)" *> *</a> *<h3>\(.*20..\), *\(.*\)</h3>X\
    <item>\
        <title>\2, \3</title>\
        <link>http://ffmpeg.org/index.html#\1</link>\
        <guid>http://ffmpeg.org/index.html#\1</guid>\
    </item>\
X' >> $@
	echo '</channel>' >> $@
	echo '</rss>' >> $@


$(BOWER_COMPONENTS): $(BOWER_PACKAGES)
	bower install

$(CSS_TARGET): $(CSS_SRCS)
	mkdir -p $(CSS_DIR)
	lessc --yui-compress --clean-css $(CSS_SRCS) > $@

clean:	cleandev
distclean: cleandev cleanprod

cleandev:
	rm -rf $(DEV_TARGETS)

cleanprod:
	rm -rf $(PROD_TARGETS) $(PROD)/$(RSS_FILENAME) $(CSS_DIR) \
	$(PROD)/img $(PROD)/js $(PROD)/robots.txt $(PROD)/fonts

.PHONY: all clean cleanprod cleandev distclean predoc
