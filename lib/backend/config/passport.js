import { Strategy as JwtStrategy, ExtractJwt } from "passport-jwt";
import User from "../config/user.js";
import { configDotenv } from "dotenv";
import passport from "passport";
configDotenv();
//Authorization : Bearer <token>
const options = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: process.env.JWT_SECRET,
  algorithms: ["HS256"],
};
const strategy = new JwtStrategy(options, (payload, done) => {
  User.findOne({ _id: payload.sub})
    .then((user) => {
      if (user) {
        return done(null, user);
      } else {
        return done(null, false);
      }
    })
    .catch((err) => done(err, null));
});
passport.use(strategy);
export default passport;
/*
import base64url from "base64url";
import CryptoJS from "crypto-js";

header
payload
signature

const jwtparts = JWT.split('.');
const headerInBaset64 = jwtparts[0];
const payloadInBase64 = jwtparts[1];
const signatureInBase64 = jwtparts[2];

const decodeHeader = base64url.decode(headerInBaset64);
const payload = base64url.decode(payloadInBase64);
const signature = base64url.decode(signatureInBase64);
*/
