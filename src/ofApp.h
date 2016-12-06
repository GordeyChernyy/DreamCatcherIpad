#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxGui.h"
#include "ofxPanZoom.h"

class ofApp : public ofxiOSApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
        void drawFboTest();
    
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
        char eventString[255];

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
        ofFbo fbo;
    
        ofxPanZoom	cam;
    
        ofxButton save;
        ofxIntSlider op;
        ofxIntSlider num_points;
        ofxIntSlider dist_points;
        ofxIntSlider brush;
        ofxFloatSlider circle_radius;
        ofxToggle h_memory;
        ofxButton takePhoto;
        ofxButton pickPhoto;
        ofxToggle showPhoto;
        ofxToggle bAuto;
        ofxButton clear;
    
        ofxPanel gui;
        bool bHide;
    
        ofxiOSImagePicker camera;
        ofImage	photo;
        ofPoint imgPos;
        ofPoint prePoint;

};


