# colors


class Color:
    
    def __init__(self,color_list,name):
        
        self.color_list = color_list
        self.name = name
        
    def __getitem__(self, key):
        return self.color_list[key]    
    
    def __len__(self):
        return len(self.color_list)
    
    def gradient(self,t):
        # t must have values between 0 and 1
        t = t*(len(self.color_list))
        print(int(t))
        left_color = self.color_list[int(t)]
        right_color = self.color_list[(int(t)+1)%len(self.color_list)]
        
        col = lerpColor(left_color,right_color,0)
        return col
    
    def __str__(self):
         return self.name           
        
winter = Color(['#0D1B2A','#1B263B','#415A77','#778DA9','#E0E1DD'],"winter")
summer = Color(["#0081af","#00abe7","#56351E","#ead2ac","#eaba6b"],"summer")
autumn = Color(["#f0a202","#f18805","#d95d39","#202c59","#581f18"],"autumn")
spring = Color(["#FAC8CD","#66a182","#233329","#FFB30F","#c0d461"],"spring")
pikachu = Color(["#000000","#eabb1f","#C04A35","#846339","#daaf44","#eabb1f","#846339","#daaf44"],"pikachu")
paradise_pink = Color(["#053225","#e34a6f","#f7b2bd","#b2a198","#60a561"],"paradise_pink")
pastel  = Color(["#d6f6dd","#dac4f7","#f4989c","#ebd2b4","#acecf7"],"pastel")
pastel2 = Color(["#dd6e42","#4f6d7a","#b37ba4","#d99ac5","#acecf7"],"pastel2")
bright_winter = Color(["#2b4141","#0eb1d2","#34e4ea","#8ab9b5","#c8c2ae"],"bright_winter")
flags = Color(["#d05353","#083d77","#ebebd3","#f4d35e","#0ead69"],"flags")
midnight_gradient = Color(["#432371","#502D72","#5D3772","#6A4173","#774B74","#845575","#915F75","#9F6976","#AC7277","#B97C77","#C68678","#D39079","#E09A7A","#EDA47A","#FAAE7B"],
                          "midnight_gradient")
midnight_blue = Color(["#251101","#470024","#5b1865","#2c5784","#5688c7"],"midnight_blue")
uhh = Color(["#264653","#2a9d8f","#e9c46a","#f4a261","#e76f51"],"uhh")
neon_bf = Color(["#58EFEC","#7CCAD5","#A0A6BE","#C481A7","#E85C90"],"neon_bf")
summer_sunset = Color(["#03071e","#370617","#6a040f","#9d0208","#d00000","#dc2f02","#e85d04","#f48c06","#faa307","#ffba08"],"summer_sunset")
ice_cream_shop = Color(["#a41623","#f0f7f4","#99e1d9","#70abaf","#0f1108"],"ice_cream_shop")
clothing_store = Color(["#b388eb","#00BFB2","#f37748","#2c5784","#e5e5e5"],"clothing_store")
golden_gate = Color(["#ff8360","#c44536","#5b1865","#2c5784","#e5e5e5"],"golden_gate")
big_dip = Color(["#7a5382","#361538","#9c103e","#ad99a8","#700353"],"big_dip")
lilacs = Color(["#d98ce9","#bfa9fc","#8c75d1","#854a94","#dec3d3"],"lilacs")
lavender_blue = Color(["#d7b9d5","#f4cae0","#1d1e2c","#3f8efc","#96031a"],"lavender_blue")