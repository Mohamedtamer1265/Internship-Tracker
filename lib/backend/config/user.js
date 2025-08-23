import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
  nickname: {
    type: String,
  },
  email: {
    type: String,
    unique: true,
    required:true
  },
  hash: {
    type: String,
  },
  salt: {
    type: String,
  },
});

const User = mongoose.model("User", UserSchema);

export default User;
