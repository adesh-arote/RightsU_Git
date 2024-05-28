namespace RightsU_BLL
{
    /// <summary>
    /// Parent class for all Entities which perform DML operations
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class BusinessLogic<T> where T : class
    {
        /// <summary>
        /// Save methods can be overriden by derived classes and then invoke parents Save method
        /// </summary>
        /// <param name="objToSave"></param>
        /// <param name="objClass"></param>
        /// <param name="resultSet"></param>
        /// <returns></returns>
        public virtual bool Save(T objToSave, dynamic objClass, out dynamic resultSet)
        {
            bool IsValid = Validate(objToSave, out resultSet);
            if (IsValid)
            {
                objClass.Save(objToSave);
            }
            return IsValid;
        }

        public virtual bool Update(T objToSave, dynamic objClass, out dynamic resultSet)
        {
            bool IsValid = ValidateUpdate(objToSave, out resultSet);
            if (IsValid)
            {
                objClass.Save(objToSave);
            }
            return IsValid;
        }

        public virtual bool Delete(T objToSave, dynamic objClass, out dynamic resultSet)
        {
            bool IsValid = ValidateDelete(objToSave, out resultSet);
            if (IsValid)
            {
                objClass.Delete(objToSave);
            }
            return IsValid;
        }
        /// <summary>
        /// Validation methods to be implemented in derived class
        /// </summary>
        /// <param name="objToValidate"></param>
        /// <param name="resultSet"></param>
        /// <returns></returns>
        public abstract bool Validate(T objToValidate, out dynamic resultSet);
        public abstract bool ValidateUpdate(T objToValidate, out dynamic resultSet);
        public abstract bool ValidateDelete(T objToValidate, out dynamic resultSet);
    }
    
}
