#include "ofApp.h"
vector<ofVec2f> history; // declare an empty vector
vector<ofVec2f> fingers;
ofVec2f finger1;
ofVec2f finger2;
Boolean drag = false;
Boolean finhide = false;
int button;
float press = 0;
ofColor col;

float offsetX;
float offsetY;
int fingerDist;
int canvasW = 1024;	//these define where the camera can pan to
int canvasH = 768;
int imgW = 1024;
int imgH = 768;

float touch1x = 0;
float touch1y = 0;
ofImage Img;
Boolean showphoto = false;

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetVerticalSync(true);
    ofSetOrientation(OFXIOS_ORIENTATION_LANDSCAPE_LEFT);
    fingers.push_back(finger1);
    fingers.push_back(finger2);
    
    gui.setup();
    gui.setDefaultHeight(50);
    //gui.add(save.setup( "save drawing" ));
    gui.add(op.setup( "opacity", 20, 3, 255 ));
    gui.add(num_points.setup( "number of points", 3, 2, 20 ));
    gui.add(dist_points.setup( "point distance", 50, 6, 200 ));
    gui.add(circle_radius.setup( "circle radius", 5, 5, 200 ));
    gui.add(brush.setup( "brush", 1, 1, 4 ));
    gui.add(h_memory.setup( "history", true));
    gui.add(takePhoto.setup( "take photo" ));
    gui.add(pickPhoto.setup( "pick photo" ));
    gui.add(showPhoto.setup( "show photo", false));
    //gui.add(bAuto.setup( "auto rotation", false));
    gui.add(clear.setup( "clear" ));
    
    col = ofColor(0, op);
    bHide = true;
    
    fbo.allocate(imgW , imgH, GL_RGBA);
    fbo.begin();
	ofClear(255,255,255, 0);
    fbo.end();
    ofBackground(255, 255, 255);
    
    cam.setZoom(1.0f);
	cam.setMinZoom(0.5f);
	cam.setMaxZoom(5.0f);
	cam.setScreenSize( ofGetWidth(), ofGetHeight() ); //tell the system how large is out screen
	cam.lookAt( ofVec2f(canvasW/2, canvasH/2) );
}

//--------------------------------------------------------------
void ofApp::update(){
    cam.update(0.016f);
    if (clear) {
        history.clear();
        ofBackground(255, 255, 255,0);
        fbo.begin();
        ofClear(255,255,255, 0);
        fbo.end();
    }
    if (takePhoto) {
        camera.setMaxDimension(MAX(1024, ofGetHeight()));
        camera.openCamera();
    }
    if (pickPhoto) {
        camera.setMaxDimension(MAX(1024, ofGetHeight()));
        camera.openLibrary();
        
    }
    if(camera.getImageUpdated()){
        photo.setFromPixels(camera.getPixelsRef());
        camera.close();
    }
    if (save) {
      
    }
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    glPushMatrix();
    cam.apply();
    
    ofNoFill();
    ofSetColor(200);
    ofSetLineWidth(1.53);
    ofRect(0, 0, imgW, imgH); // border
    
    if (drag) {
        fbo.begin();
        drawFboTest();
        fbo.end();
    }
    ofSetColor(255,255,255,0);
    fbo.draw(0,0);
    
    if (showPhoto && showphoto) {
        if(photo.isAllocated()){ photo.draw(0,0); }
    }
    
    cam.reset();
    glPopMatrix();
    
    if( bHide ){
		gui.draw();
	}
}

void ofApp::drawFboTest(){
    ofEnableAlphaBlending();
    ofVec2f m;
    m.set(touch1x, touch1y);
    history.push_back(m);
    //ofNoFill();
    
    //ofSetLineWidth(1.53);
    for(int i=0; i< history.size(); i++){
        ofVec2f h = history[i];
        
        if (m.match(h, ofRandom(3, dist_points))){
            switch (brush){
                case 1:{
                    ofFill();
                    ofSetColor(col, op);
                    ofVec2f s;
                    int r = ofRandom(1, num_points);
                    if( i>r && m.distance(history[i-r])<dist_points+10){
                        s = history[i-r];
                    } else { s = m; }
                    ofTriangle(s.x, s.y, h.x,h.y, m.x,m.y);
                    break;
                }
                case 2:{
                    ofNoFill();
                    ofSetColor(col, op);
                    ofSetLineWidth(1.53);
                    ofLine(h.x, h.y, m.x, m.y);
                    break;
                }
                case 3:{
                    
                    ofVec2f s;
                    int r = ofRandom(1, num_points);
                    if( i>r && m.distance(history[i-r])<dist_points+10){
                        s = history[i-r];
                    } else { s = m; }
                    ofFill();
                    ofSetColor(col, op);
                    ofTriangle(s.x, s.y, h.x,h.y, m.x,m.y);
                    ofNoFill();
                    ofSetLineWidth(1.53);
                    ofSetColor(255,40);
                    ofTriangle(s.x, s.y, h.x,h.y, m.x,m.y);
                    break;
                }
                case 4:{
                    ofNoFill();
                    ofSetColor(col, op);
                    ofSetLineWidth(1.53);
                    ofLine(h.x, h.y, m.x, m.y);
                    ofVec2f s;
                    s = h.getMiddle(m);
                    ofCircle(s.x ,s.y,ofRandom(circle_radius));
                    break;
                }
            }
        }
    }
    ofDisableAlphaBlending();
}
//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    showphoto = false;
    cam.touchDown(touch);
    
//    if (touch.id == 1 || touch.id == 2 ) {
//        if(touch.x<100 && touch.x>0){col = ofColor(234,55,47);}
//        if(touch.x<200 && touch.x>100){col = ofColor(246,234,58);}
//        if(touch.x<300 && touch.x>200){col = ofColor(62,133,132);}
//        if(touch.x<400 && touch.x>300){col = ofColor(204,63,118);}
//        if(touch.x<500 && touch.x>400){col = ofColor(0);}
//    }
    if (touch.x < 30 && touch.y < 30 ){
        if(bHide){bHide = false;}else{bHide=true;}
    }
    //if (touch.numTouches==2) {

    //    fingers[touch.id].set(touch);
    //    finger1 = fingers[0];
    //    finger2 = fingers[1];
    //    fingerDist = fingers[0].distance(fingers[1]);
    //
    //    ofLog(OF_LOG_NOTICE, "id = %d x = %f y= %f", touch.id, fingers[touch.id].x, fingers[touch.id].y);
    //    ofLog(OF_LOG_NOTICE, "dis = %d", fingerDist);
    //}
   
}


//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    cam.touchMoved(touch); //fw event to cam
    if(touch.id == 0){
        if(touch.id == 1){
            //ofLog(OF_LOG_NOTICE, "touch%d  x=%f y=%f", touch.id, touch.x, touch.y);
        }
    }
    if (touch.numTouches==1) {
        
//        touch1x = p.x;
//        touch1y = p.y;
        drag = true;
    }else{
        
//        if (touch.numTouches==2) {
//            drag = false;
//            fingers[touch.id].set(touch);
//            offsetX = fingers[0].getMiddle(fingers[1]).x;
//            offsetY = fingers[0].getMiddle(fingers[1]).y;
//            float dist12 = fingers[0].distance(fingers[1]);
//            int dist = fingerDist - dist12;
//            zoom = ofMap(dist, zoom_max, zoom_min, 0.3f, 4.0f);
//            //ofLog(OF_LOG_NOTICE, "dist12=%f", dist12);
//        } else if(touch.numTouches==3){
//            drag = true;
//        }
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
     showphoto = true;
    cam.touchUp(touch);	//fw event to cam
    if (touch.id == 0) {
        if(h_memory){history.clear();}
        drag = false;
    }
   
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    //cam.touchDoubleTap(touch); //fw event to cam
	//cam.setZoom(1.0f);	//reset zoom
	//cam.lookAt( ofVec2f(canvasW/2, canvasH/2) ); //reset position
    //zoom = 1.0;
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

