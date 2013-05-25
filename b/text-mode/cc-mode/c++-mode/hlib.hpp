
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

int random(int mx){
  return rand()/(RAND_MAX+1.0)*mx;
}

void mt(){
  static int c=0;
  static clock_t t;
  c^=1;
  if(c)
    t=clock();
  else
    cout<<(double)(clock()-t)/CLOCKS_PER_SEC<<endl;
}

long long combi(int n,int m){
  m=m<n-m?m:n-m;
  long long a=1,b=1;
  for(;b<=m;++b)
    a=a*(b+n-m)/b;
  return a;
}

template<class T>
struct Bit{
  vector<T> a;
  Bit(int n):a(n){}
  T operator[](int p){
    T sm=0;
    for(;p>=0;p=(p&(p+1))-1)
      sm+=a[p];
    return sm;
  }
  void update(int p,T q){
    for(;p<(int)a.size();p|=p+1)
      a[p]+=q;
  }
};

template<class T>
void sieve(vector<int>& a,vector<T>& b,int i,int l,int m,T n,T o){
  int j,k;
  for(;i<m*m;i+=m){
    for(j=0;j<m;++j)
      b[j+l]=n+i+j;
    for(j=0;j<(int)a.size()&&(T)a[j]*a[j]<n+m+i;++j)
      for(k=(n+i)%a[j]?a[j]-(n+i)%a[j]:0;k<m;k+=a[j])
        b[k+l]=0;
    l=remove(b.begin()+l,b.begin()+l+m,0)-b.begin();
  }
  b.erase(lower_bound(b.begin(),b.begin()+l,o),b.end());
}
vector<int> sieve(int n){
  int i,j;
  vector<int> a(n/log(n+2)*1.1+468);
  int m=sqrt(n)+1;
  for(i=2;i<m;++i)
    a[i]=i;
  for(i=2;i*i<m;++i){
    if(!a[i])continue;
    for(j=i*i;j<m;j+=i)
      a[j]=0;
  }
  sieve(a,a,m,remove(a.begin(),a.begin()+m,0)-a.begin(),m,0,n);
  return a;
}
vector<long long> sieve(long long n,long long o){
  vector<int> a=sieve(sqrt(o)+1);
  vector<long long> b(o/log(o+2)*1.1-n/log(n+2)+469);
  int l=copy(lower_bound(a.begin(),a.end(),n),a.end(),b.begin())-b.begin();
  sieve(a,b,0,l,sqrt(o-n-l)+1,max<long long>(n,sqrt(o)+1),o);
  return b;
}

bool isPrime(long long p){
  long long i;
  if(p==1||!(p&1))
    return p==2;
  for(i=3;i*i<=p&&p%i;i+=2);
  return i*i>p;
}

struct Factor{
  vector<int> a;
  vector<pair<long long,int> > b;
  vector<long long> c;
  Factor(long long p):a(sieve(sqrt(p)+1)){}
  void f(int p,long long q){
    int i;
    if(p==(int)b.size()){
      c.push_back(q);
      return;
    }
    long long pi=1;
    for(i=0;i<b[p].second+1;++i){
      f(p+1,q*pi);
      pi*=b[p].first;
    }
  }
  vector<long long> get(long long p){
    int i,j;
    b.clear();
    for(i=0;i<(int)a.size()&&(long long)a[i]*a[i]<=p;++i){
      for(j=0;!(p%a[i]);++j)
        p/=a[i];
      if(j)
        b.push_back(make_pair(a[i],j));
    }
    if(p!=1)
      b.push_back(make_pair(p,1));
    c.clear();
    f(0,1);
    return c;
  }
};

/*
struct Power{
  vector<int> a;
  vector<vector<long long> > b[63];
  Power(int* p,int* q,int n):a(n){
    int i,j,k,l;
    copy(p,p+n,a.begin());
    for(i=0;i<63;++i)
      b[i].assign(n,vector<long long>(n));
    for(i=0;i<n;++i)
      for(j=0;j<n;++j)
        b[0][i][j]=*(q+n*i+j);
    for(i=1;i<63;++i)
      for(j=0;j<n;++j)
        for(k=0;k<n;++k)
          for(l=0;l<n;++l)
            b[i][j][k]=(b[i][j][k]+b[i-1][j][l]*b[i-1][l][k])%mod;
  }
  vector<int> pow(long long p){
    int i,j;
    vector<int> d=a,e(d.size());
    for(i=0;p;++i){
      if(p&1){
        for(j=0;j<(int)e.size();++j)
          e[j]=inner_product(d.begin(),d.end(),b[i][j].begin(),0ll)%mod;
        swap(d,e);
      }
      p>>=1;
    }
    return d;
  }
};
*/

struct Radix{
  const char* s;
  int a[128];
  Radix(const char* s="0123456789ABCDEF"):s(s){
    int i;
    for(i=0;s[i];++i)
      a[(int)s[i]]=i;
  }
  string to(long long p,int q){
    int i;
    if(!p)
      return "0";
    char t[64]={};
    for(i=62;p;--i){
      t[i]=s[p%q];
      p/=q;
    }
    return string(t+i+1);
  }
  string to(const string& t,int p,int q){
    return to(to(t,p),q);
  }
  long long to(const string& t,int p){
    int i;
    long long sm=a[(int)t[0]];
    for(i=1;i<(int)t.length();++i)
      sm=sm*p+a[(int)t[i]];
    return sm;
  }
};

vector<string> split(const string& s,const string& t,bool p=false){
  int i,j;
  vector<string> a;
  for(i=0;(j=s.find(t,i))!=string::npos;i=j+t.length())
    a.push_back(s.substr(i,j-i));
  a.push_back(s.substr(i));
  if(p)
    a.erase(remove(a.begin(),a.end(),""),a.end());
  return a;
}

template<class T>
void print(T p,T q,char c){
  if(p!=q){
    cout<<*p;
    ++p;
  }
  for(;p!=q;++p)
    cout<<c<<*p;
  cout<<endl;
}

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
  void operator+=(int p){
    x+=dx*p;
    y+=dy*p;
  }
  int operator-(const mIterator& mi){
    return dx?(mi.x-x)*dx:(mi.y-y)*dy;
  }
};

