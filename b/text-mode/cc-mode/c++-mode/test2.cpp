#include<deque>
#include<list>
#include<map>
#include<queue>
#include<set>
#include<stack>
#include<vector>
#include<algorithm>
#include<string>
#include<iostream>
#include<numeric>
#include<cmath>
#include<cstdio>
#include<cstring>
using namespace std;

struct mIterator{
  int x,y,dx,dy,ex,ey,w,h;
  mIterator(int w,int h,int p):w(w),h(h){
    x=p==5?w-1:0;
    y=p==3||p==5;
    dx=p>3?-1:p!=1;
    dy=!!p;
    ex=p==1||p==2||p==4;
    ey=!ex;;
  }
  mIterator(int x,int y,int dx,int dy,int ex,int ey,int w,int h):
    x(x),y(y),dx(dx),dy(dy),ex(ex),ey(ey),w(w),h(h){}
  mIterator& operator++(){
    x+=dx;
    y+=dy;
    return *this;
  }
  mIterator operator++(int){
    mIterator mi=*this;
    ++*this;
    return mi;
  }
  bool operator==(const mIterator& mi)const{
    return x==mi.x&&y==mi.y;
  }
  bool operator!=(const mIterator& mi)const{
    return !(*this==mi);
  }
  mIterator begin()const{
    return mIterator(x,y,ex,ey,dx,dy,w,h);
  }
  mIterator end()const{
    int p=min(ex?(ex>0?w-x:x+1):0x7fffffff,ey?(ey>0?h-y:y+1):0x7fffffff);
    return mIterator(x+ex*p,y+ey*p,ex,ey,dx,dy,w,h);
  }
};
void advance(mIterator& mi,int p){
  mi.x+=mi.dx*p;
  mi.y+=mi.dy*p;
}
int distance(const mIterator& mi,const mIterator& mj){
  return mi.dx?(mj.x-mi.x)*mi.dx:(mj.y-mi.y)*mi.dy;
}

int main(){
  int i;

  mIterator m(3,3,1);

  advance(m,3);

  return 0;
}
