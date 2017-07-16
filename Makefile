include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCPage
CCPage_FILES = Tweak.xm
CCPage_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
        install.exec "killall -9 SpringBoard"
