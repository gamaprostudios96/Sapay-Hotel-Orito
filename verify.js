// Verifica el token de Cloudflare Turnstile en el servidor. La clave secreta va en la variable de entorno TURNSTILE_SECRET de Vercel.
module.exports=async(req,res)=>{
  if(req.method!=="POST")return res.status(405).json({ok:false});
  const token=(req.body||{}).token;
  if(!token||!process.env.TURNSTILE_SECRET)return res.status(400).json({ok:false});
  try{
    const r=await fetch("https://challenges.cloudflare.com/turnstile/v0/siteverify",{method:"POST",headers:{"content-type":"application/x-www-form-urlencoded"},body:new URLSearchParams({secret:process.env.TURNSTILE_SECRET,response:token})});
    const j=await r.json();return res.status(200).json({ok:!!j.success});
  }catch(e){return res.status(500).json({ok:false})}
};
